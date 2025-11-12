// lib/features/home/home_binding.dart

import 'package:get/get.dart';
import 'package:grocer_ai/features/onboarding/location/location_repository.dart';
import 'package:grocer_ai/features/orders/controllers/order_controller.dart';
import 'package:grocer_ai/features/profile/controllers/profile_controller.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut and find the controllers that are already
    // registered in AppBindings.
    Get.lazyPut<HomeController>(() => HomeController(
      Get.find<ProfileController>(),
      Get.find<WalletController>(),
      Get.find<LocationRepository>(),
      Get.find<OrderController>(),
    ));
  }
}