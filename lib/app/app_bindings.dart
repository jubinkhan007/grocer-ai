import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/profile/controllers/partner_controller.dart';
import '../features/profile/controllers/referral_controller.dart';
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

  }
}
