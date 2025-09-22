import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final loading = false.obs;
  final obscure = true.obs;

  // Simple error messages shown as little bubbles
  final emailError = RxnString();
  final passError = RxnString();

  void toggleObscure() => obscure.value = !obscure.value;

  bool _validate() {
    emailError.value = null;
    passError.value = null;

    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailOk) emailError.value = 'Email is wrong';

    if (pass.length < 6) passError.value = 'Password is wrong';

    return emailError.value == null && passError.value == null;
  }

  Future<void> signIn() async {
    if (!_validate()) return;

    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    loading.value = false;

    // TODO: call your Auth API; for now, simulate failure or success.
    // Get.offAllNamed(Routes.home);
    Get.snackbar(
      'Signed in',
      'Welcome back!',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }

  void forgotPassword() {
    Get.snackbar('Forgot Password', 'Hook this to your reset flow');
  }

  void google() {
    Get.snackbar('Google', 'Continue with Google');
  }

  void facebook() {
    Get.snackbar('Facebook', 'Continue with Facebook');
  }

  void apple() {
    Get.snackbar('Apple', 'Continue with Apple');
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }
}
