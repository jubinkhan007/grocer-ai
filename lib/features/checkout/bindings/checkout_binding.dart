// lib/features/checkout/bindings/checkout_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/checkout/controllers/add_payment_method_controller.dart';
import 'package:grocer_ai/features/checkout/controllers/checkout_controller.dart';
import 'package:grocer_ai/features/checkout/services/checkout_service.dart';
import 'package:grocer_ai/features/onboarding/location/location_repository.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    // Register the service for this feature
    // --- MODIFIED: Added fenix: true ---
    Get.lazyPut(() => CheckoutService(Get.find<DioClient>()), fenix: true);

    // Register the LocationRepository (if not already registered)
    if (!Get.isRegistered<LocationRepository>()) {
      // --- MODIFIED: Added fenix: true ---
      Get.lazyPut(() => LocationRepository(Get.find<DioClient>()), fenix: true);
    }

    // Register the controllers
    // --- MODIFIED: Added fenix: true ---
    Get.lazyPut(() => CheckoutController(
      Get.find<CheckoutService>(),
      Get.find<LocationRepository>(),
    ), fenix: true);

    // --- MODIFIED: Added fenix: true ---
    Get.lazyPut(() => AddPaymentMethodController(
      Get.find<CheckoutService>(),
    ), fenix: true);
  }
}