// lib/features/profile/referrals/referral_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/profile/controllers/referral_controller.dart';
import 'package:grocer_ai/features/profile/services/referral_service.dart';

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    // Service is already registered globally in AppBindings, so we find it
    if (!Get.isRegistered<ReferralService>()) {
      Get.lazyPut(() => ReferralService(Get.find()));
    }
    // LazyPut the controller
    Get.lazyPut(() => ReferralController(Get.find<ReferralService>()));
  }
}