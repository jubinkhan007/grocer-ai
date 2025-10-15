// lib/features/onboarding/location/location_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'location_controller.dart';
import 'location_repository.dart';

class LocationPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationRepository(Get.find<DioClient>()));
    Get.put(LocationController());
  }
}
