// lib/features/offer/controllers/offer_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/offer/services/offer_service.dart';
import 'package:grocer_ai/features/preferences/preferences_controller.dart';
import 'package:grocer_ai/features/onboarding/location/models/user_location_model.dart'; // <-- 1. IMPORT

import '../../onboarding/location/location_repository.dart';
import '../../profile/controllers/profile_controller.dart';

class OfferController extends GetxController {
  final OfferService _service;
  final ProfileController _profileController;
  final PreferencesController _prefsController;
  final LocationRepository _locationRepo; // <-- 2. ADD REPO

  OfferController(
      this._service,
      this._profileController,
      this._prefsController,
      this._locationRepo, // <-- 3. ADD TO CONSTRUCTOR
      );

  final isLoading = true.obs;
  final error = RxnString();
  final offerData = <ProviderWithProducts>[].obs;

  // --- Dynamic User Data ---
  final RxString userName = "User".obs;
  final RxString location = "Your Location".obs;
  final hasUnreadNotifications = true.obs; // TODO: Add logic for this

  // --- 4. ADD LOCAL LIST FOR LOCATIONS ---
  final userLocations = <UserLocation>[].obs;

  @override
  void onInit() {
    super.onInit();
    _syncUserData();
    loadOffers();
  }

  /// Fetches user's name from Profile and location from Preferences
  void _syncUserData() async {
    // --- 5. LOAD LOCATIONS ---
    await _loadLocations();

    // Listen for changes to the profile info
    ever(_profileController.personalInfo, (info) {
      if (info?.name != null && info!.name!.isNotEmpty) {
        userName.value = info.name!.split(' ').first; // Show first name
      }
    });

    // --- 6. FIX: Listen to local userLocations list ---
    ever(userLocations, (locations) {
      final loc = locations.firstOrNull;
      if (loc != null) {
        location.value = loc.label; // Use label (e.g., "Home")
      }
    });

    // Load initial data if already available
    if (_profileController.personalInfo.value != null) {
      final info = _profileController.personalInfo.value;
      if (info?.name != null && info!.name!.isNotEmpty) {
        userName.value = info.name!.split(' ').first;
      }
    }

    // --- 7. FIX: Use local userLocations list ---
    final loc = userLocations.firstOrNull;
    if (loc != null) {
      location.value = loc.label;
    }
  }

  // --- 8. ADD NEW METHOD TO LOAD LOCATIONS ---
  Future<void> _loadLocations() async {
    try {
      userLocations.assignAll(await _locationRepo.fetchUserLocations());
    } catch (e) {
      print("OfferController: Failed to load locations: $e");
    }
  }


  Future<void> loadOffers() async {
    try {
      isLoading.value = true;
      error.value = null;
      final data = await _service.getOffers();
      offerData.assignAll(data);
    } catch (e) {
      error.value = "Failed to load offers. Please try again.";
      print(e); // For debugging
    } finally {
      isLoading.value = false;
    }
  }
}