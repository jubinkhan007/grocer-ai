// lib/features/onboarding/location/location_controller.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'location_permission_view.dart';
import 'location_repository.dart';

/// NEW: who started the location flow (login vs signup)
enum LocationFlowOrigin { login, signup }

class LocationController extends GetxController {
  final loading = false.obs;
  final repo = LocationRepository(Get.find<DioClient>());

  /// Remember who opened the gate (default = login)
  final flowOrigin = LocationFlowOrigin.login.obs;

  /// True only if device location is ON and permission is granted
  Future<bool> _hasRuntimePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    final p = await Geolocator.checkPermission();
    return p == LocationPermission.always || p == LocationPermission.whileInUse;
  }

  /// True only if the backend already has at least one saved location
  Future<bool> hasSavedLocationInBackend() async {
    try {
      final list = await repo.fetchUserLocations();
      return list.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Call this right after login/signup. If it returns false, we already
  /// navigated into the location flow and you must stop the caller's flow.
  Future<bool> enforceLocationGate({required LocationFlowOrigin origin}) async {
    flowOrigin.value = origin;

    final hasPermission = await _hasRuntimePermission();
    final hasSaved = await hasSavedLocationInBackend();

    if (!hasPermission || !hasSaved) {
      Get.offAll(() => const LocationPermissionView());
      return false; // user is now in the location flow
    }
    return true; // ok to continue
  }

  Future<void> requestAndSaveLocation() async {
    loading.value = true;

    try {
      // 1) Ensure location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        loading.value = false;
        return;
      }

      // 2) Check & request permission
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

      // 3) Fetch current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4) Reverse geocode
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

      // 5) Save to backend
      await repo.saveUserLocation(
        label: label,
        address: address,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // 6) Navigate based on origin
      final next = (flowOrigin.value == LocationFlowOrigin.signup)
          ? Routes.prefsGrocers   // only after sign-up
          : Routes.main;          // after login

      Get.offAllNamed(next);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      loading.value = false;
    }
  }
}
