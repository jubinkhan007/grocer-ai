import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/orders/controllers/compare_grocers_controller.dart';
import 'package:grocer_ai/features/orders/services/order_preference_service.dart';

// --- FIX: Import the correct service file ---
import '../services/compare_bid_service.dart';

class CompareGrocersBinding extends Bindings {
  @override
  void dependencies() {
    // --- FIX: Use the correct class name 'CompareBidService' ---
    Get.lazyPut(() => CompareBidService(Get.find<DioClient>()));

    // This check ensures it's available if this screen is loaded deeply
    if (!Get.isRegistered<OrderPreferenceService>()) {
      Get.lazyPut(() => OrderPreferenceService(Get.find<DioClient>()));
    }

    Get.lazyPut(() => CompareGrocersController(
      // --- FIX: Pass the correct class 'CompareBidService' ---
        Get.find<CompareBidService>(),
        Get.find<OrderPreferenceService>()));
  }
}
