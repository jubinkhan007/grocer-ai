import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/auth/data/auth_repository.dart';

import '../onboarding/location/location_controller.dart' as loc;
import 'auth_controller.dart';

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

      final tokens = await _repo.register(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        referralCode: referralCtrl.text.trim().isEmpty ? null : referralCtrl.text.trim(),
        mobileNumber: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
      );

      // persist + inject like login
      Get.find<AuthController>().loginSuccess(tokens.accessToken, tokens.refreshToken);
      await _box.write('auth_token', tokens.accessToken);
      await _box.write('refresh_token', tokens.refreshToken);
      final dio = Get.find<DioClient>();
      dio.dio.options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';

      // 🔒 Enforce location gate for **SIGNUP**
      final lc = Get.isRegistered<loc.LocationController>()
          ? Get.find<loc.LocationController>()
          : Get.put(loc.LocationController());

      final ok = await lc.enforceLocationGate(origin: loc.LocationFlowOrigin.signup);
      if (!ok) {
        // We already navigated into the permission UI.
        // After user allows & we save the location, LocationController will
        // auto-route to Routes.prefsGrocers for signup flow. Do nothing here.
        return;
      }

      // If permission + saved location already exist, go to prefs now.
      Get.offAllNamed(Routes.prefsGrocers);

    } on ApiFailure catch (e) {
      loading.value = false;

      final emailMsg = e.firstFor('email');
      final passMsg = e.firstFor('password');
      final nameMsg = e.firstFor('name');
      final refMsg  = e.firstFor('referral_code');

      if (emailMsg != null) emailError.value = emailMsg;
      if (passMsg  != null) passError.value  = passMsg;
      if (nameMsg  != null) nameError.value  = nameMsg;
      if (refMsg   != null) referralErr.value = refMsg;

      if (emailMsg == null && passMsg == null && nameMsg == null && refMsg == null) {
        Get.snackbar('Sign Up failed', e.message);
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Sign Up failed', 'Unexpected error: $e');
    } finally {
      loading.value = false;
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
