// lib/features/checkout/controllers/add_payment_method_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/checkout/models/payment_method_model.dart';
import 'package:grocer_ai/features/checkout/models/user_payment_method_model.dart';
import 'package:grocer_ai/features/checkout/services/checkout_service.dart';

class AddPaymentMethodController extends GetxController {
  final CheckoutService _service;
  AddPaymentMethodController(this._service);

  final paymentMethodTypes = <PaymentMethod>[].obs;
  final userPaymentMethods = <UserPaymentMethod>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadMethods();
  }

  Future<void> loadMethods() async {
    try {
      isLoading.value = true;
      // Fetch both lists in parallel
      final futures = [
        _service.fetchPaymentMethods(),
        _service.fetchUserPaymentMethods(),
      ];
      final results = await Future.wait(futures);

      paymentMethodTypes.assignAll(results[0] as List<PaymentMethod>);
      userPaymentMethods.assignAll(results[1] as List<UserPaymentMethod>);
    } catch (e) {
      Get.snackbar('Error', 'Could not load payment methods: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMethod(int id) async {
    try {
      await _service.deleteUserPaymentMethod(id);
      userPaymentMethods.removeWhere((m) => m.id == id);
      Get.snackbar('Success', 'Payment method removed.');
    } catch (e) {
      Get.snackbar('Error', 'Could not remove method: $e');
    }
  }

  void handleAddNewMethod(PaymentMethod methodType) {
    // This is where you would trigger the native SDK (e.g., Stripe)
    // For now, we'll simulate it.

    if (methodType.key == 'stripe_card') {
      // 1. The UI would navigate to `AddNewCardScreen`
      // 2. That screen would use the Stripe SDK to get a "pm_xxx" token.
      // 3. It would call back to this controller with that token.
      Get.snackbar('Not Implemented', 'Stripe SDK flow starts here.');

      // --- SIMULATION ---
      // We'll just pretend we got a token and save it.
      _saveNewCard(methodType.id, "pm_simulated_123456");

    } else {
      Get.snackbar('Not Implemented', '${methodType.name} flow starts here.');
    }
  }

  Future<void> _saveNewCard(int methodId, String providerToken) async {
    try {
      final newMethod = await _service.saveUserPaymentMethod(
        paymentMethodId: methodId,
        providerPaymentId: providerToken,
      );
      userPaymentMethods.add(newMethod);
      Get.back(); // Go back from AddPaymentMethodScreen to CheckoutScreen
      Get.snackbar('Success', 'New card added.');
    } catch (e) {
      Get.snackbar('Error', 'Could not save new card: $e');
    }
  }
}