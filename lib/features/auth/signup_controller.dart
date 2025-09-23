import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final referralCtrl = TextEditingController();

  final loading = false.obs;
  final obscure = true.obs;

  final nameError = RxnString();
  final emailError = RxnString();
  final passError = RxnString();
  final referralErr =
      RxnString(); // optional; left unused unless you want rules

  void toggleObscure() => obscure.value = !obscure.value;

  bool _validate() {
    nameError.value = emailError.value = passError.value = referralErr.value =
        null;

    if (nameCtrl.text.trim().length < 2) {
      nameError.value = 'Name is too short';
    }
    final email = emailCtrl.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      emailError.value = 'Email is wrong';
    }
    if (passCtrl.text.length < 6) {
      passError.value = 'Password is too short';
    }
    // referral optional → add rules if needed

    return [
      nameError.value,
      emailError.value,
      passError.value,
      referralErr.value,
    ].every((e) => e == null);
  }

  Future<void> signUp() async {
    if (!_validate()) return;
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    loading.value = false;

    Get.snackbar(
      'Account created',
      'Welcome to GrocerAI!',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
    // TODO: Navigate to your next screen (e.g., home/verify)
  }

  void forgotPassword() {
    Get.snackbar('Forgot Password', 'Hook this to your reset flow');
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    referralCtrl.dispose();
    super.onClose();
  }
}
