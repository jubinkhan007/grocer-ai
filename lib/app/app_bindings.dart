// lib/app/app_bindings.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../core/auth/current_user_service.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/home/home_controller.dart';
import '../features/home/services/dashboard_service.dart';
import '../features/home/services/preference_service.dart';
import '../features/notification/controllers/notification_controller.dart';
import '../features/notification/services/notification_service.dart';
import '../features/offer/controllers/offer_controller.dart';
import '../features/offer/services/offer_service.dart';
import '../features/onboarding/location/location_repository.dart';
import '../features/orders/controllers/order_controller.dart';
import '../features/orders/controllers/past_order_details_controller.dart';
import '../features/orders/services/order_service.dart';
import '../features/preferences/preferences_controller.dart';
import '../features/preferences/preferences_repository.dart'; // <-- 1. IMPORT
import '../features/profile/controllers/dashboard_preference_controller.dart';
import '../features/profile/controllers/partner_controller.dart';
import '../features/profile/controllers/referral_controller.dart';
import '../features/profile/controllers/referral_summary_controller.dart';
import '../features/profile/security/controllers/security_controller.dart';
import '../features/profile/security/services/security_service.dart';
import '../features/profile/services/dashboard_preference_service.dart';
import '../features/profile/services/partner_service.dart';
import '../features/profile/services/profile_service.dart';
import '../features/profile/controllers/profile_controller.dart';
import '../features/profile/services/referral_service.dart';
import '../features/profile/services/referral_summary_service.dart';
import '../features/profile/wallet/wallet_controller.dart';
import '../features/profile/wallet/wallet_service.dart';
import '../shell/main_shell_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Storage first (used by Dio interceptor)
    Get.putAsync<GetStorage>(() async {
      await GetStorage.init();
      return GetStorage();
    }, permanent: true);
    // Storage
    Get.putAsync<GetStorage>(() async {
      await GetStorage.init();
      return GetStorage();
    }, permanent: true);

// Current user (decoded from JWT)
    Get.lazyPut<CurrentUserService>(
          () => CurrentUserService(Get.find<GetStorage>()),
      fenix: true,
    );
    Get.lazyPut<MainShellController>(() => MainShellController());
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    // Core clients/repos
    Get.put<DioClient>(DioClient(), permanent: true);
    Get.put<AuthRepository>(AuthRepository(Get.find<DioClient>()), permanent: true);

    // --- 2. ADD PreferencesRepository and PreferencesController ---
    // These are needed by OfferController, so they must be registered first.
    // We use Get.put(..., permanent: true) so it's available for the whole app lifecycle.
    Get.lazyPut<PreferencesRepository>(() => PreferencesRepository(Get.find<DioClient>()), fenix: true);
    Get.put(PreferencesController(Get.find<PreferencesRepository>()), permanent: true);

    // --- 3. ADD LocationRepository ---
    Get.lazyPut<LocationRepository>(() => LocationRepository(Get.find<DioClient>()), fenix: true);
    // --- END ADD ---


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

    Get.lazyPut<WalletService>(
          () => WalletService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<WalletController>(
          () => WalletController(Get.find<WalletService>()),
      fenix: true,
    );

    Get.lazyPut<OrderService>(
          () => OrderService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<OrderController>(
          () => OrderController(Get.find<OrderService>()),
      fenix: true,
    );



    Get.lazyPut<OfferService>(
          () => OfferService(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<OfferController>(
          () => OfferController(
        Get.find<OfferService>(),
        Get.find<ProfileController>(),
        Get.find<PreferencesController>(), // <-- This will now succeed
        Get.find<LocationRepository>(),  // <-- This will now succeed
      ),
      fenix: true,
    );

    // --- 2. ADD DashboardService ---
    Get.lazyPut<DashboardService>(() => DashboardService(Get.find<DioClient>()), fenix: true);
    Get.lazyPut<PreferenceService>(() => PreferenceService(Get.find<DioClient>()), fenix: true);

// lib/app/app_bindings.dart
    Get.lazyPut<HomeController>(
          () => HomeController(
        Get.find<ProfileController>(),
        Get.find<WalletController>(),
        Get.find<LocationRepository>(),
        Get.find<OrderController>(),
            Get.find<DashboardService>(),
            Get.find<PreferenceService>(),
      ),
      fenix: true,
    );
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

  }
}