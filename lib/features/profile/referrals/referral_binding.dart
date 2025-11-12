// lib/features/profile/referrals/referral_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/profile/controllers/referral_controller.dart';
import 'package:grocer_ai/features/profile/services/referral_service.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_controller.dart';

// --- 1. IMPORT NEW FILES ---
import '../../../core/auth/current_user_service.dart';
import '../controllers/referral_summary_controller.dart';
import '../services/referral_summary_service.dart';
// --- END IMPORT ---

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    // Service is already registered globally in AppBindings, so we find it
    if (!Get.isRegistered<ReferralService>()) {
      Get.lazyPut(() => ReferralService(Get.find<DioClient>()));
    }
    // LazyPut the controller for MyReferralScreen
    Get.lazyPut(() => ReferralController(Get.find<ReferralService>()));

    // --- 2. ADD NEW DEPENDENCIES ---
    Get.lazyPut<ReferralSummaryService>(
          () => ReferralSummaryService(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<ReferralSummaryController>(
          () => ReferralSummaryController(
        Get.find<ReferralSummaryService>(),
        Get.find<WalletController>(),
        Get.find<CurrentUserService>(),
      ),
      fenix: true,
    );
    // --- END ADD ---
  }
}