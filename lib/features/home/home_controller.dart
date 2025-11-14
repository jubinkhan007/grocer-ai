// lib/features/home/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/home/services/dashboard_service.dart';
import 'package:grocer_ai/features/home/services/preference_service.dart';
import 'package:grocer_ai/features/onboarding/location/location_repository.dart';
import 'package:grocer_ai/features/onboarding/location/models/user_location_model.dart';
import 'package:grocer_ai/features/orders/controllers/order_controller.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_controller.dart';

import '../../shell/main_shell_controller.dart';
import '../profile/controllers/profile_controller.dart';
import 'dashboard_screen.dart';
import 'models/banner_model.dart';
import 'models/dashboard_stats_model.dart';
import 'models/preference_completeness_model.dart';

class HomeController extends GetxController {
  final ProfileController _profileController;
  final WalletController _walletController;
  final LocationRepository _locationRepo;
  final OrderController _orderController;
  final DashboardService _dashboardService;
  final PreferenceService _preferenceService;

  HomeController(
      this._profileController,
      this._walletController,
      this._locationRepo,
      this._orderController,
      this._dashboardService,
      this._preferenceService,
      );

  final userLocations = <UserLocation>[].obs;

  // Expose reactive getters for the UI
  RxString get userName => _profileController.personalInfo.value?.name?.split(' ').first.obs ?? 'User'.obs;
  RxString get location => userLocations.firstOrNull?.label.obs ?? 'Your Location'.obs;
  RxString get totalCredit => _walletController.wallet.value?.usableBalance.obs ?? '0.00'.obs;
  Rxn get lastOrder => _orderController.currentOrder;
  RxBool get isLoadingLastOrder => _orderController.isLoadingCurrent;

  final banners = <BannerModel>[].obs;
  final lastMonthStats = Rxn<LastMonthStats>();
  final analysisStats = Rxn<AnalysisStats>();

  final isLoadingBanners = true.obs;
  final isLoadingStats = true.obs;
  final isLoadingAnalysis = true.obs;

  String get lastMonthSavings =>
      lastMonthStats.value?.totalSaved.toStringAsFixed(0) ?? '...';
  final hasUnreadNotifications = true.obs;

  // NEW: preference completeness state
  final Rxn<PreferenceCompleteness> prefCompleteness = Rxn<PreferenceCompleteness>();
  final isLoadingPref = false.obs;

  double get preferencePercent0to1 {
    final pct = prefCompleteness.value?.overallPercentage ?? 0.0;
    return (pct / 100.0).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    _syncUserData();
    _loadDashboardData();
    _loadPreferenceCompleteness(); // <-- NEW
  }

  // New private method to load locations
  Future<void> _loadLocations() async {
    try {
      userLocations.assignAll(await _locationRepo.fetchUserLocations());
    } catch (e) {
      print("HomeController: Failed to load locations: $e");
    }
  }

  Future<void> _loadPreferenceCompleteness() async {
    try {
      isLoadingPref.value = true;
      prefCompleteness.value = await _preferenceService.fetchCompleteness();
    } catch (e) {
      // keep silent (no UI change), optionally log
      // Get.snackbar('Error', 'Could not load preferences completeness.');
    } finally {
      isLoadingPref.value = false;
    }
  }

  Future<void> maybePromptToCompletePreferences(BuildContext context) async {
    // ensure data is present (lightweight; cached if already loaded)
    if (prefCompleteness.value == null && !isLoadingPref.value) {
      await _loadPreferenceCompleteness();
    }

    final pct = prefCompleteness.value?.overallPercentage ?? 0.0;
    if (pct < 100.0) {
      await showCompletePreferenceDialog(
        context: context,
        percent: preferencePercent0to1,
        onEdit: onEditPreferences,
        onSkip: onSkipPreferences,
      );
    } else {
      onPlaceNewOrder();
    }
  }


  void _syncUserData() {
    _profileController.loadPersonalInfo();
    _walletController.loadWallet();
    _loadLocations();
    // --- THIS IS THE FIX ---
    // _orderController.loadCurrentOrder(); // REMOVED: This method is private in OrderController
    // --- END FIX ---
  }

  Future<void> _loadDashboardData() async {
    // Reset loading states
    isLoadingBanners.value = true;
    isLoadingStats.value = true;
    isLoadingAnalysis.value = true;

    // Fetch all in parallel
    try {
      await Future.wait([
        _loadBanners(),
        _loadStats(),
        _loadAnalysis(),
      ]);
    } catch (e) {
      // Errors are handled inside the individual methods with snackbars
      print("Error loading dashboard data: $e");
    }
  }

  Future<void> _loadBanners() async {
    try {
      banners.assignAll(await _dashboardService.fetchBanners());
    } catch (e) {
      Get.snackbar('Error', 'Could not load promos.');
    } finally {
      isLoadingBanners.value = false;
    }
  }

  Future<void> _loadStats() async {
    try {
      lastMonthStats.value = await _dashboardService.fetchLastMonthStats();
    } catch (e) {
      Get.snackbar('Error', 'Could not load monthly stats.');
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> _loadAnalysis() async {
    try {
      analysisStats.value = await _dashboardService.fetchAnalysisStats();
    } catch (e) {
      Get.snackbar('Error', 'Could not load analysis.');
    } finally {
      isLoadingAnalysis.value = false;
    }
  }


  void onEditPreferences() {
    // This logic is already in MainShellController, we just call it
    Get.find<MainShellController>().openPreferences();
  }

  void onSkipPreferences() {
    Get.back(); // Just close the dialog
  }

  void onSeeAllOrders() {
    final shell = Get.find<MainShellController>();
    shell.goTo(2); // Switch to Order tab
  }

  void onPlaceNewOrder() {
    // This is a placeholder. You have a complex flow for this.
    // We can implement the "Complete Preference" dialog logic here.
    // For now, let's just navigate to the Order tab.
    final shell = Get.find<MainShellController>();
    shell.goTo(2); // Switch to Order tab
  }
}