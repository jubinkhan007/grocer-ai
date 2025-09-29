// lib/features/auth/forgot/forgot_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_routes.dart';
import '../data/auth_repository.dart';

class ForgotController extends GetxController {
  final emailCtrl = TextEditingController();
  final loading = false.obs;
  final error = RxnString();

  final _repo = Get.find<AuthRepository>();

  Future<void> send() async {
    error.value = null;
    final email = emailCtrl.text.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!ok) {
      error.value = 'Enter a valid email';
      return;
    }

    loading.value = true;
    try {
      await _repo.requestPasswordReset(email);
      loading.value = false;
      Get.toNamed(Routes.otp, arguments: {'email': email});
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
      Get.snackbar('Failed', error.value!);
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }
}
