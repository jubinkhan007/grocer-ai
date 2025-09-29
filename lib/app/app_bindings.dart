import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../features/auth/data/auth_repository.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<GetStorage>(() async {
      await GetStorage.init();
      return GetStorage();
    }, permanent: true);
    Get.put(DioClient(), permanent: true);
    Get.put(AuthRepository(Get.find<DioClient>()), permanent: true);
  }
}
