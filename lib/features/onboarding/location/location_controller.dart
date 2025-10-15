import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'location_repository.dart';

class LocationController extends GetxController {
  final loading = false.obs;
  final repo = LocationRepository(Get.find<DioClient>());

  Future<void> requestAndSaveLocation() async {
    loading.value = true;

    try {
      // 1️⃣ Ensure location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        loading.value = false;
        return;
      }

      // 2️⃣ Check & request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission denied', 'Please allow location access.');
          loading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission denied',
          'Please enable location permission from system settings.',
        );
        loading.value = false;
        return;
      }

      // 3️⃣ Fetch current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4️⃣ Reverse geocode
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = '';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        address =
            '${p.street ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}, ${p.country ?? ''}';
      }

      const label = 'Current Location';

      // 5️⃣ Save to backend
      await repo.saveUserLocation(
        label: label,
        address: address,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // 6️⃣ Navigate to next screen
      Get.offAllNamed(Routes.prefsGrocers);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      loading.value = false;
    }
  }
}
