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
    Get.lazyPut(() => CheckoutService(Get.find<DioClient>()));

    // Register the LocationRepository (if not already registered)
    // The CheckoutController needs this to fetch saved addresses.
    if (!Get.isRegistered<LocationRepository>()) {
      Get.lazyPut(() => LocationRepository(Get.find<DioClient>()));
    }

    // Register the controllers
    Get.lazyPut(() => CheckoutController(
      Get.find<CheckoutService>(),
      Get.find<LocationRepository>(),
    ));

    Get.lazyPut(() => AddPaymentMethodController(
      Get.find<CheckoutService>(),
    ));

    // Note: We don't create a binding for AddNewCardScreen here,
    // as its logic will be handled by AddPaymentMethodController.
  }
}