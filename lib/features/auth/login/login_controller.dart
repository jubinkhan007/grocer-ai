import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/auth/data/auth_repository.dart';

import '../auth_controller.dart';

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

  final _repo = Get.find<AuthRepository>();
  final _box = Get.find<GetStorage>();

  Future<void> signIn() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

    emailError.value = null;
    passError.value = null;

    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return;
    }
    if (pass.isEmpty) {
      passError.value = 'Password is required';
      return;
    }

    try {
      loading.value = true;
      final tokens = await _repo.login(email: email, password: pass);

      // Update the central AuthController state
      Get.find<AuthController>().loginSuccess(tokens.accessToken, tokens.refreshToken);
      // Persist tokens again just to be safe
      await _box.write('auth_token', tokens.accessToken);
      await _box.write('refresh_token', tokens.refreshToken);

      // Inject token into Dio for live session use
      final dio = Get.find<DioClient>();
      dio.dio.options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';

      loading.value = false;

      // ✅ Navigate to your shell Home screen
      Get.offAllNamed(Routes.main);
    } on ApiFailure catch (e) {
      loading.value = false;

      switch (e.code) {
        case 'email_not_found':
        case 'invalid_email':
          emailError.value = e.message;
          return;
        case 'invalid_password':
        case 'password_wrong':
          passError.value = e.message;
          return;
        case 'network_error':
          Get.snackbar('No Internet', 'Check your connection and try again');
          return;
      }

      final msg = e.message.toLowerCase();
      if (msg.contains('email')) {
        emailError.value = e.message;
      } else if (msg.contains('password')) {
        passError.value = e.message;
      } else {
        Get.snackbar('Login failed', e.message);
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Login failed', 'Unexpected error: $e');
    }
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
