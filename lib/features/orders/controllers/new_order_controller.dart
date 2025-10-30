// lib/features/orders/controllers/new_order_controller.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/orders/models/order_preference_model.dart';
import 'package:grocer_ai/features/orders/services/order_preference_service.dart';
import 'package:grocer_ai/features/orders/views/store_order_screen.dart';
import 'package:permission_handler/permission_handler.dart';

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
    try {
      isLoading.value = true;
      final savedPrefs = await _service.fetchSavedPreferences();
      final questions  = await _service.fetchOrderPreferences();

      for (final saved in savedPrefs) {
        if (saved.selectedOption != null) {
          answers[saved.preference] = saved.selectedOption;
        } else if (saved.additionInfo != null) {
          answers[saved.preference] = saved.additionInfo;
        }
      }

      preferences.assignAll(questions);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load order preferences: $e');
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
      Get.snackbar('Save Error', 'Failed to save preference: $e');
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
      Get.snackbar('Error', 'Failed to generate order: $e');
    } finally {
      isGeneratingOrder.value = false;
    }
  }

  /// Upload receipt flow: permission -> pick -> upload -> save (ids or urls)
  Future<void> uploadReceipt(int preferenceId, {int? selectedOptionId}) async {
    // (Optional) Ask storage/photos permissions to avoid OEM quirks
    final ok = await _ensureFileAccessPermission();
    if (!ok) {
      Get.snackbar('Permission', 'Storage/Photos permission denied.');
      return;
    }

    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    final uploaded = await _mediaSvc.uploadMany(result.files);

    // Prefer IDs when backend returns them
    final ids = uploaded.where((m) => m.id != null).map((m) => m.id!).toList();
    if (ids.isNotEmpty) {
      await _orderSvc.saveWithFileIds(
        preferenceId: preferenceId,
        selectedOptionId: selectedOptionId,
        fileIds: ids,
      );
      Get.snackbar('Uploaded', 'Files saved to your preference.');
      return;
    }

    // Otherwise send URLs (ensure server accepts `file_urls`)
    final urls = uploaded.map((m) => m.url).toList();
    await _orderSvc.saveWithFileUrls(
      preferenceId: preferenceId,
      selectedOptionId: selectedOptionId,
      urls: urls,
    );
    Get.snackbar('Uploaded', 'Files saved to your preference.');
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
