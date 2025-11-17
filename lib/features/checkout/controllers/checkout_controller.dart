// lib/features/checkout/controllers/checkout_controller.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/checkout/models/time_slot_model.dart';
import 'package:grocer_ai/features/checkout/models/user_payment_method_model.dart';
import 'package:grocer_ai/features/checkout/services/checkout_service.dart';
import 'package:grocer_ai/features/onboarding/location/location_repository.dart';
import 'package:grocer_ai/features/onboarding/location/models/user_location_model.dart';
import 'package:grocer_ai/features/orders/models/create_order_request.dart';
import 'package:grocer_ai/features/orders/models/generated_order_model.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart';

class CheckoutController extends GetxController {
  final CheckoutService _checkoutService;
  final LocationRepository _locationRepo;

  CheckoutController(this._checkoutService, this._locationRepo);

  // Data from the previous (StoreOrder) screen
  late final GeneratedOrderResponse orderData;
  bool _hasInitialized = false; // Flag to prevent snackbar on hot reload

  // API-driven lists
  final timeSlots = <TimeSlot>[].obs;
  final userLocations = <UserLocation>[].obs;
  final userPaymentMethods = <UserPaymentMethod>[].obs;

  // Loading states
  final isLoading = true.obs;
  final isPlacingOrder = false.obs;

  // User selections from the UI
  final selectedSlotId = RxnInt();
  final selectedLocationId = RxnInt();
  final selectedPaymentMethodId = RxnInt();
  final redemptionAmount = 0.0.obs;
  final fulfillmentMethod = 'home_delivery'.obs; // or 'store_pickup' // Matches UI default
  final creditEnabled = false.obs;
  final isSavingLocation = false.obs;


  @override
  void onInit() {
    super.onInit();
    // --- MODIFIED: Argument check is now safe ---
    if (Get.arguments is Map &&
        Get.arguments['orderData'] is GeneratedOrderResponse) {
      orderData = Get.arguments['orderData'];
      _hasInitialized = true;
    } else {
      _hasInitialized = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // --- MODIFIED: All logic moved to onReady ---
    if (!_hasInitialized) {
      // Show error AFTER build
      Get.snackbar('Error', 'No order data found. Please go back.');
      Get.back();
      return;
    }
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      // Fetch all data in parallel
      final futures = [
        _checkoutService.fetchTimeSlots(),
        _locationRepo.fetchUserLocations(),
        _checkoutService.fetchUserPaymentMethods(),
      ];

      final results = await Future.wait(futures);

      timeSlots.assignAll(results[0] as List<TimeSlot>);
      userLocations.assignAll(results[1] as List<UserLocation>);
      userPaymentMethods.assignAll(results[2] as List<UserPaymentMethod>);

      // Pre-select first items if available
      if (timeSlots.isNotEmpty) selectedSlotId.value = timeSlots.first.id;
      if (userLocations.isNotEmpty) selectedLocationId.value = userLocations.first.id;
      if (userPaymentMethods.isNotEmpty) {
        // Auto-select the default card if one exists
        final defaultCard =
        userPaymentMethods.firstWhereOrNull((m) => m.isDefault);
        selectedPaymentMethodId.value =
            defaultCard?.id ?? userPaymentMethods.first.id;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load checkout data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Helpers to translate
  String get uiFulfillment =>
      (fulfillmentMethod.value == 'home_delivery') ? 'delivery' : 'pickup';


  // --- UI Actions ---
  void selectTimeSlot(int id) => selectedSlotId.value = id;
  void selectLocation(int id) => selectedLocationId.value = id;
  void selectPaymentMethod(int id) => selectedPaymentMethodId.value = id;
  // UI passes 'delivery' or 'pickup'
  void setFulfillmentMethod(String uiValue) {
    fulfillmentMethod.value =
    (uiValue == 'delivery') ? 'home_delivery' : 'store_pickup';
  }
  void toggleCredit(bool enabled) => creditEnabled.value = enabled;

  // --- Helper for TimingCard ---
  void selectTimeSlotByLabel(String label) {
    final selected = timeSlots.firstWhereOrNull((ts) => ts.timeSlot == label);
    if (selected != null) {
      selectedSlotId.value = selected.id;
    }
  }

  // --- Helper for TimingCard ---
  String get selectedTimeSlotLabel {
    return timeSlots
        .firstWhereOrNull((ts) => ts.id == selectedSlotId.value)
        ?.timeSlot ??
        '';
  }

  UserLocation? get selectedLocation {
    return userLocations
        .firstWhereOrNull((loc) => loc.id == selectedLocationId.value);
  }

  UserPaymentMethod? get selectedPaymentMethod {
    return userPaymentMethods
        .firstWhereOrNull((pm) => pm.id == selectedPaymentMethodId.value);
  }

  // --- Helpers for InvoiceCard ---
  double get orderValue =>
      double.tryParse(orderData.provider.discountedPrice) ?? 0.0;
  double get redeemedValue => creditEnabled.value ? redemptionAmount.value : 0.0;
  double get dueToday =>
      (orderValue - redeemedValue).clamp(0.0, double.infinity);
  double get totalValue => orderValue; // Assuming total is the same as order value

  // --- 3. ADD THIS NEW METHOD ---
  Future<void> saveNewLocation({
    required String label,
    required String address,
  }) async {
    if (isSavingLocation.value) return;

    if (label.isEmpty || address.isEmpty) {
      Get.snackbar('Error', 'Please fill out both label and address.');
      return;
    }

    try {
      isSavingLocation.value = true;

      // Show loader
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      double? latitude;
      double? longitude;

// Try geocoding (non-fatal if it fails)
      try {
        final locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          final lat = locations.first.latitude;
          final lng = locations.first.longitude;

          // Normalize to backend constraints:
          // - max_digits=9, decimal_places=6 is typical
          latitude = double.parse(lat.toStringAsFixed(6));
          longitude = double.parse(lng.toStringAsFixed(6));
        }
      } catch (_) {
        // ignore geocoding errors
      }

// Fallbacks if geocoding failed
      latitude ??= 0.0;
      longitude ??= 0.0;

// Call backend to save
      await _locationRepo.saveUserLocation(
        label: label,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );

      // Refresh all checkout data (incl. locations)
      await _loadInitialData();

      // Try to select the newly added one
      final newLoc = userLocations.firstWhereOrNull(
            (loc) => loc.label == label && loc.address == address,
      );

      if (newLoc != null) {
        selectedLocationId.value = newLoc.id;
      }

      // Close loader
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Note: DO NOT pop screens here.
      // Let the caller decide (dialog/screen knows what to close).
      Get.snackbar('Success', 'Address added.');
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar('Error', 'Failed to save address: $e');
    } finally {
      isSavingLocation.value = false;
    }
  }




  Future<void> proceedToPay() async {
    if (isPlacingOrder.value) return;

    // --- Validation ---
    if (selectedLocationId.value == null) {
      Get.snackbar('Error', 'Please select a delivery address.');
      return;
    }
    if (selectedSlotId.value == null) {
      Get.snackbar('Error', 'Please select a delivery time slot.');
      return;
    }
    if (selectedPaymentMethodId.value == null) {
      Get.snackbar('Error', 'Please add or select a payment method.');
      return;
    }
    // --- End Validation ---

    try {
      isPlacingOrder.value = true;
      Get.dialog(
          const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white)),
          barrierDismissible: false);

      // 1. Create the Order
      final request = CreateOrderRequest(
        providerId: orderData.provider.id,
        price: orderData.provider.totalPrice,
        discount: (double.parse(orderData.provider.totalPrice) - orderValue).toString(),
        redeemFromWallet: redeemedValue.toString(),
        totalItems: orderData.products.length,
        deliveryMethod: fulfillmentMethod.value,
        deliverySlotId: selectedSlotId.value!,
        deliveryAddressId: selectedLocationId.value!,
        products: orderData.products,
      );

      final createdOrder = await _checkoutService.createOrder(request);

      // 2. Pay for the Order
      await _checkoutService.payForOrder(
        orderId: createdOrder.id,
        userPaymentMethodId: selectedPaymentMethodId.value!,
      );

      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog
      isPlacingOrder.value = false;

      // 3. Navigate to Success
      Get.offNamed(Routes.orderSuccess, arguments: createdOrder);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      isPlacingOrder.value = false;
      Get.snackbar('Payment Failed', e.toString());
    }
  }


  Future<void> addNewLocation(String label, String address) async {
    if (isSavingLocation.value) return;

    try {
      isSavingLocation.value = true;

      // 1. Get coordinates from the address string
      //    (Requires the 'geocoding' package: pub.dev/packages/geocoding)
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        Get.snackbar('Error', 'Could not find coordinates for that address.');
        isSavingLocation.value = false;
        return;
      }

      double latitude = locations.first.latitude;
      double longitude = locations.first.longitude;

      // 2. Call the repository method
      await _locationRepo.saveUserLocation(
        label: label,
        address: address,
        latitude: latitude,
        longitude: longitude,
      ); //

      // 3. Refresh the list of locations
      await _loadInitialData(); // This will re-fetch all checkout data including new location

      // 4. Go back to the address selection screen
      Get.back(); // Close AddNewLocationScreen

      // 5. (Optional) Select the new address and close the selection screen
      final newLocation = userLocations.firstWhereOrNull((loc) => loc.address == address);
      if (newLocation != null) {
        selectLocation(newLocation.id);
        Get.back(); // Close SetNewLocationScreen
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to save address: $e');
    } finally {
      isSavingLocation.value = false;
    }
  }
}