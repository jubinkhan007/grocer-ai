// lib/features/checkout/controllers/checkout_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/checkout/models/time_slot_model.dart';
import 'package:grocer_ai/features/checkout/models/user_payment_method_model.dart';
import 'package:grocer_ai/features/checkout/services/checkout_service.dart';
import 'package:grocer_ai/features/onboarding/location/location_repository.dart';
import 'package:grocer_ai/features/onboarding/location/models/user_location_model.dart';
import 'package:grocer_ai/features/orders/models/create_order_request.dart';
import 'package:grocer_ai/features/orders/models/generated_order_model.dart';
import 'package:grocer_ai/app/app_routes.dart';

class CheckoutController extends GetxController {
  final CheckoutService _checkoutService;
  final LocationRepository _locationRepo;

  CheckoutController(this._checkoutService, this._locationRepo);

  // Data from the previous (StoreOrder) screen
  late final GeneratedOrderResponse orderData;

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
  final fulfillmentMethod = 'delivery'.obs; // Matches UI default
  final creditEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the order details passed from StoreOrderScreen
    if (Get.arguments is GeneratedOrderResponse) {
      orderData = Get.arguments;
    } else {
      // This should not happen in the normal flow
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
        selectedPaymentMethodId.value = userPaymentMethods.first.id;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load checkout data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // --- UI Actions ---
  void selectTimeSlot(int id) => selectedSlotId.value = id;
  void selectLocation(int id) => selectedLocationId.value = id;
  void selectPaymentMethod(int id) => selectedPaymentMethodId.value = id;
  void setFulfillmentMethod(String method) => fulfillmentMethod.value = method;
  void toggleCredit(bool enabled) => creditEnabled.value = enabled;

  UserLocation? get selectedLocation {
    return userLocations
        .firstWhereOrNull((loc) => loc.id == selectedLocationId.value);
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
        discount: (double.parse(orderData.provider.totalPrice) -
            double.parse(orderData.provider.discountedPrice))
            .toString(),
        redeemFromWallet: creditEnabled.value ? redemptionAmount.value.toString() : '0.00',
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

      if (Get.isDialogOpen!) Get.back(); // Close loading dialog
      isPlacingOrder.value = false;

      // 3. Navigate to Success
      // We pass the order details to the success screen
      Get.offNamed(Routes.orderSuccess, arguments: createdOrder);
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      isPlacingOrder.value = false;
      Get.snackbar('Payment Failed', e.toString());
    }
  }
}