// lib/features/checkout/controllers/add_payment_method_controller.dart

import 'package:get/get.dart';
import 'package:grocer_ai/features/checkout/models/payment_method_model.dart';
import 'package:grocer_ai/features/checkout/models/user_payment_method_model.dart';
import 'package:grocer_ai/features/checkout/services/checkout_service.dart';
import 'package:grocer_ai/features/checkout/views/add_new_card_screen.dart'; // ⬅️ make sure this import exists

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
      final results = await Future.wait([
        _service.fetchPaymentMethods(),
        _service.fetchUserPaymentMethods(),
      ]);

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
    if (methodType.key == 'stripe_card' || methodType.key == 'card') {
      // We navigate to AddNewCardScreen and pass ONLY the method id.
      Get.to(
            () => const AddNewCardScreen(),
        arguments: methodType.id,
      );
    } else {
      Get.snackbar('Not supported', '${methodType.name} is not supported yet.');
    }
  }

  Future<void> saveNewCard(int methodId, String providerToken) async {
    try {
      final newMethod = await _service.saveUserPaymentMethod(
        paymentMethodId: methodId,
        providerPaymentId: providerToken,
      );
      userPaymentMethods.add(newMethod);

      // Go back to the list (AddPaymentMethodScreen) and show success
      Get.back();
      Get.snackbar('Success', 'New card added.');
    } catch (e) {
      Get.snackbar('Error', 'Could not save new card: $e');
    }
  }
}
