import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/auth/data/auth_repository.dart';

import 'forgot_controller.dart';
import 'otp_controller.dart';
import 'reset_controller.dart';

class ForgotBinding extends Bindings {
  @override
  void dependencies() {
    // Network + repo (if not already registered elsewhere)
    if (!Get.isRegistered<DioClient>()) {
      Get.put(DioClient(), permanent: true);
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put(AuthRepository(Get.find<DioClient>()), permanent: true);
    }

    // Controllers for the 3 screens
    Get.lazyPut(() => ForgotController());
    Get.lazyPut(() => OtpController());
    Get.lazyPut(() => ResetController());
  }
}
