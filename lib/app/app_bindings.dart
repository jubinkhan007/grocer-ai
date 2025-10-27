// lib/app/app_bindings.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/notification/controllers/notification_controller.dart';
import '../features/notification/services/notification_service.dart';
import '../features/profile/controllers/dashboard_preference_controller.dart';
import '../features/profile/controllers/partner_controller.dart';
import '../features/profile/controllers/referral_controller.dart';
import '../features/profile/security/controllers/security_controller.dart';
import '../features/profile/security/services/security_service.dart';
import '../features/profile/services/dashboard_preference_service.dart';
import '../features/profile/services/partner_service.dart';
import '../features/profile/services/profile_service.dart';
import '../features/profile/controllers/profile_controller.dart';
import '../features/profile/services/referral_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Storage first (used by Dio interceptor)
    Get.putAsync<GetStorage>(() async {
      await GetStorage.init();
      return GetStorage();
    }, permanent: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    // Core clients/repos
    Get.put<DioClient>(DioClient(), permanent: true);
    Get.put<AuthRepository>(AuthRepository(Get.find<DioClient>()), permanent: true);

    // Register service BEFORE controller
    Get.lazyPut<ProfileService>(
          () => ProfileService(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
          () => ProfileController(Get.find<ProfileService>()),
      fenix: true,
    );
    Get.lazyPut<PartnerService>(
          () => PartnerService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<PartnerController>(
          () => PartnerController(Get.find<PartnerService>()),
      fenix: true,
    );
    Get.lazyPut<ReferralService>(
          () => ReferralService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<ReferralController>(
          () => ReferralController(Get.find<ReferralService>()),
      fenix: true,
    );
    Get.lazyPut<NotificationService>(
          () => NotificationService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<NotificationController>(
          () => NotificationController(Get.find<NotificationService>()),
      fenix: true,
    );
    Get.lazyPut<DashboardPreferenceService>(
          () => DashboardPreferenceService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<DashboardPreferenceController>(
          () => DashboardPreferenceController(Get.find<DashboardPreferenceService>()),
      fenix: true,
    );
    Get.lazyPut<SecurityService>(
          () => SecurityService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<SecurityController>(
          () => SecurityController(Get.find<SecurityService>()),
      fenix: true,
    );




  }
}
