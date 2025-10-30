// New File
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/bindings/store_order_binding.dart';
import 'package:grocer_ai/features/orders/models/compare_bid_model.dart';
import 'package:grocer_ai/features/orders/views/store_order_screen.dart';

// --- RENAMED ---
import '../services/compare_bid_service.dart';
import '../services/order_preference_service.dart';
import '../models/generated_order_model.dart';
import 'new_order_controller.dart';

class CompareGrocersController extends GetxController {
  // --- RENAMED ---
  final CompareBidService _compareService;
  final OrderPreferenceService _orderService;

  CompareGrocersController(this._compareService, this._orderService);

  final bids = <CompareBid>[].obs;
  final isLoading = true.obs;
  final isRebidding = false.obs;
  final isLive = false.obs; // To control the "Live Bid Status" UI
  final secondsLeft = 0.obs;
  Timer? _ticker;
  int? _lastPreferenceId;

  @override
  void onInit() {
    super.onInit();
    // --- FIX for lastWhereOrNull Error ---
    // We find the 'text' preference from the NewOrderController to use as a key
    try {
      final textPref = Get.find<NewOrderController>().preferences.firstWhere(
            (p) => p.preferenceType == 'text',
      );
      _lastPreferenceId = textPref.id;
    } catch (e) {
      _lastPreferenceId = null;
      Get.snackbar('Error', 'Could not find the original order preference. Please try again.');
    }
    loadBids();
  }

  Future<void> loadBids() async {
    try {
      isLoading.value = true;
      bids.assignAll(await _compareService.fetchBids());
    } catch (e) {
      Get.snackbar('Error', 'Could not load comparison bids: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _startLiveTimer({int seconds = 90}) {
    _ticker?.cancel();
    secondsLeft.value = seconds;
    isLive.value = true;

    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = secondsLeft.value - 1;
      if (next <= 0) {
        t.cancel();
        secondsLeft.value = 0;
        isLive.value = false;       // show Rebid again
        isRebidding.value = false;  // make the button clickable again
      } else {
        secondsLeft.value = next;
      }
    });
  }

  // Public formatted time for the UI: MM:SS
  String get formattedTime {
    final s = secondsLeft.value;
    final m = s ~/ 60;
    final sec = s % 60;
    final mm = m.toString().padLeft(1, '0'); // 0..9 fine
    final ss = sec.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> handleRebid() async {
    try {
      // show loader on the chip while we hit the API
      isRebidding.value = true;

      // flip to Live view and start the countdown
      isLive.value = true;
      _startLiveTimer(seconds: 90);

      // do the API call
      final result = await _compareService.rebid();

      // ✅ stop showing the loader and show the timer instead
      bids.assignAll(result);
      isRebidding.value = false;  // <-- add this line
    } catch (e) {
      // On error, stop live & allow retry
      _ticker?.cancel();
      isLive.value = false;
      isRebidding.value = false;
      Get.snackbar('Error', 'Could not rebid: $e');
    }
  }

  Future<void> selectStore(CompareBid bid) async {
    if (_lastPreferenceId == null) {
      Get.snackbar('Error', 'Could not find the original order to generate. Please go back.');
      return;
    }
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      final orderData = await _orderService.generateOrderList(
        preferenceId: _lastPreferenceId!,
        providerId: bid.provider.id,
      );
      if (Get.isDialogOpen ?? false) Get.back();
      Get.to(() => const StoreOrderScreen(),
          arguments: {'orderData': orderData, 'fromCompare': true},
          binding: StoreOrderBinding());
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar('Error', 'Could not generate list for ${bid.provider.name}: $e');
    }
  }

  void toggleLiveView() {
    isLive.value = !isLive.value;
  }
}

