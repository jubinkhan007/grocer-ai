import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/auth/data/auth_repository.dart';

class SignUpController extends GetxController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final referralCtrl = TextEditingController(); // optional
  final phoneCtrl = TextEditingController(); // optional if you need it later

  final loading = false.obs;
  final obscure = true.obs;

  // bubble errors
  final nameError = RxnString();
  final emailError = RxnString();
  final passError = RxnString();
  final referralError = RxnString();

  // <-- ADD: alias to match the view usage
  RxnString get referralErr => referralError;

  // <-- ADD: used by the "Forgot Password?" link in the view
  void forgotPassword() {
    Get.toNamed(Routes.forgot);
  }

  void toggleObscure() => obscure.value = !obscure.value;

  final _repo = Get.find<AuthRepository>();
  final _box = Get.find<GetStorage>();

  bool _validate() {
    nameError.value = null;
    emailError.value = null;
    passError.value = null;
    referralError.value = null;

    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (name.length < 2) nameError.value = 'Enter your name';
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailOk) emailError.value = 'Email is wrong';
    if (pass.length < 6) passError.value = 'At least 6 characters';

    return nameError.value == null &&
        emailError.value == null &&
        passError.value == null;
  }

  Future<void> signUp() async {
    if (!_validate()) return;

    try {
      loading.value = true;

      await _repo.register(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        referralCode: referralCtrl.text.trim().isEmpty
            ? null
            : referralCtrl.text.trim(),
        mobileNumber: phoneCtrl.text.trim().isEmpty
            ? null
            : phoneCtrl.text.trim(),
      );

      loading.value = false;

      // We received tokens from register; treat as logged in.
      // Navigate to the app shell (or wherever you want).
      Get.offAllNamed(Routes.main);
    } on ApiFailure catch (e) {
      loading.value = false;

      // Map common server codes/messages to the right bubble.
      switch (e.code) {
        case 'email_exists':
        case 'email_already_used':
          emailError.value = 'Email already exists';
          return;
        case 'invalid_email':
          emailError.value = e.message;
          return;
        case 'weak_password':
        case 'invalid_password':
          passError.value = e.message;
          return;
        case 'invalid_name':
          nameError.value = e.message;
          return;
        case 'invalid_referral':
        case 'referral_not_found':
          referralError.value = e.message;
          return;
        case 'network_error':
          Get.snackbar('No Internet', 'Check your connection and try again');
          return;
      }

      // Heuristic fallback by inspecting the message
      final msg = (e.message ?? '').toLowerCase();
      if (msg.contains('email')) {
        emailError.value = e.message;
      } else if (msg.contains('password')) {
        passError.value = e.message;
      } else if (msg.contains('name')) {
        nameError.value = e.message;
      } else if (msg.contains('referral')) {
        referralError.value = e.message;
      } else {
        Get.snackbar('Sign Up failed', e.message ?? 'Unknown error');
      }
    } catch (_) {
      loading.value = false;
      Get.snackbar('Sign Up failed', 'Unexpected error');
    }
  }

  // Optional placeholders for social taps (keeps your UI callbacks intact)
  void google() => Get.snackbar('Google', 'Continue with Google');
  void facebook() => Get.snackbar('Facebook', 'Continue with Facebook');
  void apple() => Get.snackbar('Apple', 'Continue with Apple');

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    referralCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
