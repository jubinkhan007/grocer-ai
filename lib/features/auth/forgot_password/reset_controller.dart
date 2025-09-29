// lib/features/auth/forgot/reset_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_routes.dart';
import '../data/auth_repository.dart';

class ResetController extends GetxController {
  final passCtrl = TextEditingController();
  final obscure = true.obs;
  final loading = false.obs;
  final error = RxnString();

  late final String uid;
  late final String token;

  final _repo = Get.find<AuthRepository>();

  @override
  void onInit() {
    final a = (Get.arguments as Map?) ?? {};
    uid = a['uid'] ?? '';
    token = a['token'] ?? '';
    super.onInit();
  }

  void toggle() => obscure.value = !obscure.value;

  Future<void> submit() async {
    error.value = null;
    if (passCtrl.text.length < 6) {
      error.value = 'Minimum 6 characters';
      return;
    }

    loading.value = true;
    try {
      await _repo.confirmNewPassword(
        uid: uid,
        token: token,
        password: passCtrl.text,
      );
      loading.value = false;
      Get.snackbar('Success', 'Password updated');
      Get.offAllNamed(Routes.login);
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
      Get.snackbar('Failed', error.value!);
    }
  }

  @override
  void onClose() {
    passCtrl.dispose();
    super.onClose();
  }
}
