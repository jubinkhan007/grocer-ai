// lib/features/orders/controllers/new_order_controller.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/orders/models/order_preference_model.dart';
import 'package:grocer_ai/features/orders/services/order_preference_service.dart';
import 'package:grocer_ai/features/orders/views/store_order_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/network/dio_pretty.dart';
import '../../../media/services/media_service.dart';
import '../bindings/store_order_binding.dart';
import '../models/generated_order_model.dart';

class NewOrderController extends GetxController {
  final OrderPreferenceService _service;   // fetch + basic save
  final OrderPreferenceService _orderSvc;  // save with ids/urls
  final MediaService _mediaSvc;

  /// Single-arg constructor that your Binding can satisfy.
  NewOrderController(DioClient client)
      : _service  = OrderPreferenceService(client),
        _orderSvc = OrderPreferenceService(client),
        _mediaSvc = MediaService(client);

  final isLoading = true.obs;
  final preferences = <OrderPreferenceItem>[].obs;
  final isGeneratingOrder = false.obs;

  // --- NEW: Store ID for the selected store on this screen ---
  // We'll default to 1 (Walmart) based on the static UI
  final selectedStoreId = 1.obs;
  final filesByPref = <int, List<PreferenceFile>>{}.obs;

  /// Currently selected store on the New Order screen
  final RxString selectedStore = 'Walmart'.obs;
  void selectStore(String store) => selectedStore.value = store;

  /// Answers by preference id
  final answers = <int, dynamic>{}.obs;

  final Map<int, TextEditingController> _textControllers = {};

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final questions = await _service.fetchOrderPreferences();
      preferences.assignAll(questions);

      final saved = await _service.fetchSavedPreferences();
      // seed answers + files map
      filesByPref.clear();
      for (final s in saved) {
        if (s.selectedOption != null) {
          answers[s.preference] = s.selectedOption;
        } else if ((s.additionInfo ?? '').isNotEmpty) {
          answers[s.preference] = s.additionInfo;
        }
        filesByPref[s.preference] = s.files; // <-- keep files
      }
      filesByPref.refresh();
    } finally {
      isLoading.value = false;
    }
  }

  TextEditingController getTextController(OrderPreferenceItem pref) {
    if (_textControllers.containsKey(pref.id)) {
      return _textControllers[pref.id]!;
    }
    final savedText = (answers[pref.id] as String?) ?? '';
    final controller = TextEditingController(text: savedText);
    controller.addListener(() {
      final text = controller.text;
      if (answers[pref.id] != text) {
        answers[pref.id] = text;
        savePreference(pref.id, text: text);
      }
    });
    _textControllers[pref.id] = controller;
    return controller;
  }

  void selectOption(int preferenceId, int optionId) {
    if (answers[preferenceId] == optionId) return;
    answers[preferenceId] = optionId;
    answers.refresh();
    savePreference(preferenceId, selectedOptionId: optionId);
  }

  Future<void> savePreference(
      int preferenceId, {
        int? selectedOptionId,
        String? text,
      }) async {
    try {
      final payload = OrderPreferenceRequest(
        preference: preferenceId,
        selectedOption: selectedOptionId,
        additionInfo: text,
      );
      await _service.saveOrderPreference(payload);
    } catch (e) {
      Get.snackbar(
        'Error',
        DioPretty.message(e),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.95),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 6),
      );
    }
  }

  bool shouldShowUpload(OrderPreferenceItem item) {
    if (!item.allowFiles) return false;
    final selectedOptionId = answers[item.id];
    return selectedOptionId == item.triggerOption;
  }

  /// --- MODIFIED: onContinue ---
  void onContinue() async {
    try {
      isGeneratingOrder.value = true;

      // 1. Find the "additional info" preference
      final textPref = preferences.firstWhereOrNull(
            (p) => p.preferenceType == 'text',
      );

      if (textPref == null) {
        throw Exception('Could not find text preference to submit.');
      }

      final prefId = textPref.id;
      final addInfoText = _textControllers[prefId]?.text;
      // 1. Save the final text field first
      await savePreference(prefId, text: addInfoText);

      // 2. Call the service method that gets the order list
      final GeneratedOrderResponse orderData =
      await _service.generateOrderList(
        preferenceId: prefId,
        additionInfo: addInfoText,
        providerId: selectedStoreId.value,
      );

      // 3. Navigate to StoreOrderScreen with the data
      Get.to(
            () => const StoreOrderScreen(),
        arguments: orderData,
        binding: StoreOrderBinding(),
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        DioPretty.message(e),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.95),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 6),
      );
    } finally {
      isGeneratingOrder.value = false;
    }
  }

  /// Upload receipt flow: permission -> pick -> upload -> save (ids or urls)
  Future<void> uploadReceipt(int preferenceId, {int? selectedOptionId}) async {
    final ok = await _ensureFileAccessPermission();
    if (!ok) { Get.snackbar('Permission', 'Storage/Photos permission denied.'); return; }

    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    final uploaded = await _mediaSvc.uploadMany(result.files);

    final ids = uploaded.where((m) => m.id != null).map((m) => m.id!).toList();
    if (ids.isNotEmpty) {
      await _orderSvc.saveWithFileIds(
        preferenceId: preferenceId,
        selectedOptionId: selectedOptionId,
        fileIds: ids,
      );
    } else {
      final urls = uploaded.map((m) => m.url).toList();
      await _orderSvc.saveWithFileUrls(
        preferenceId: preferenceId,
        selectedOptionId: selectedOptionId,
        urls: urls,
      );
    }

    Get.snackbar('Uploaded', 'Files saved to your preference.');

    // 🔄 refresh saved so UI shows files
    await _refreshSinglePref(preferenceId);
  }
  Future<void> _refreshSinglePref(int prefId) async {
    // simplest: re-fetch all saved and update maps
    final saved = await _service.fetchSavedPreferences();
    for (final s in saved) {
      if (s.preference == prefId) {
        filesByPref[prefId] = s.files;
      }
      // also keep answers in sync if needed
      if (s.selectedOption != null) answers[s.preference] = s.selectedOption;
      if ((s.additionInfo ?? '').isNotEmpty) answers[s.preference] = s.additionInfo;
    }
    answers.refresh();
    filesByPref.refresh();
  }
  Future<void> openFile(PreferenceFile f) async {
    final uri = Uri.parse(f.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Unable to open', f.url);
    }
  }

  Future<bool> _ensureFileAccessPermission() async {
    // file_picker usually works without manual permission on modern Android/iOS,
    // but this avoids OEM issues.
    final storage = await Permission.storage.request();
    if (storage.isGranted || storage.isLimited) return true;

    final photos = await Permission.photos.request();
    return photos.isGranted || photos.isLimited;
  }
}
