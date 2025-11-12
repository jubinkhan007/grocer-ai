// lib/features/home/home_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/onboarding/location/location_repository.dart';
import 'package:grocer_ai/features/onboarding/location/models/user_location_model.dart'; // <-- 1. IMPORT
import 'package:grocer_ai/features/orders/controllers/order_controller.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_controller.dart';

import '../../shell/main_shell_controller.dart';
import '../profile/controllers/profile_controller.dart';

class HomeController extends GetxController {
  final ProfileController _profileController;
  final WalletController _walletController;
  final LocationRepository _locationRepo;
  final OrderController _orderController;

  HomeController(
      this._profileController,
      this._walletController,
      this._locationRepo,
      this._orderController,
      );

  // --- 2. ADD LOCAL LIST FOR LOCATIONS ---
  final userLocations = <UserLocation>[].obs;

  // Expose reactive getters for the UI
  RxString get userName => _profileController.personalInfo.value?.name?.split(' ').first.obs ?? 'User'.obs;
  // --- 3. FIX: Read from the local userLocations list ---
  RxString get location => userLocations.firstOrNull?.label.obs ?? 'Your Location'.obs;
  RxString get totalCredit => _walletController.wallet.value?.usableBalance.obs ?? '0.00'.obs;
  Rxn get lastOrder => _orderController.currentOrder;
  RxBool get isLoadingLastOrder => _orderController.isLoadingCurrent;

  // TODO: Wire up savings and notification dot
  final RxString lastMonthSavings = "18".obs;
  final hasUnreadNotifications = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Data is already being loaded by the other controllers
    // registered in AppBindings. We just need to listen.

    // We can add 'ever' listeners here if we need to react to changes,
    // but for this screen, just reading the .value in the Obx is sufficient.

    // We should, however, ensure the dependent data is fresh.
    _profileController.loadPersonalInfo();
    _walletController.loadWallet();
    _loadLocations(); // <-- 4. CALL new method
    // --- 5. REMOVED: This method is private in OrderController ---
    // _orderController.loadCurrentOrder();
    // --- END FIX ---
  }

  // --- 6. ADD: New private method to load locations ---
  Future<void> _loadLocations() async {
    try {
      userLocations.assignAll(await _locationRepo.fetchUserLocations());
    } catch (e) {
      print("HomeController: Failed to load locations: $e");
    }
  }
  // --- END ADD ---


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