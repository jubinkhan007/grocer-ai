// lib/features/preferences/preferences_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/preferences/preferences_controller.dart';
import 'package:grocer_ai/features/preferences/preferences_repository.dart';

class PreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreferencesRepository(Get.find<DioClient>()));
    Get.put(PreferencesController(Get.find<PreferencesRepository>()));
  }
}
