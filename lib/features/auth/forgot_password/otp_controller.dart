import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../data/auth_repository.dart';

class OtpController extends GetxController {
  final code = ''.obs; // concatenated 6 digits
  final loading = false.obs;
  final error = RxnString();

  // Timer state
  final secondsLeft = 120.obs; // 2 minutes
  final resendLoading = false.obs;
  Timer? _ticker;

  late final String email;
  final _repo = Get.find<AuthRepository>();

  @override
  void onInit() {
    email = (Get.arguments as Map?)?['email'] ?? '';
    _startTimer();
    super.onInit();
  }

  String get timerText {
    final s = secondsLeft.value;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _startTimer() {
    _ticker?.cancel();
    secondsLeft.value = 120; // reset to 2:00 each time you start
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        t.cancel();
      }
    });
  }

  Future<void> resend() async {
    if (secondsLeft.value > 0 || resendLoading.value) return;
    resendLoading.value = true;
    try {
      await _repo.requestPasswordReset(email);
      Get.snackbar('Sent', 'OTP resent to $email');
      _startTimer();
    } catch (e) {
      Get.snackbar('Resend failed', e.toString());
    } finally {
      resendLoading.value = false;
    }
  }

  Future<void> verify() async {
    error.value = null;
    if (code.value.length != 6) {
      error.value = 'Enter 6-digit code';
      return;
    }
    loading.value = true;
    try {
      final r = await _repo.verifyOtp(email: email, code: code.value);
      loading.value = false;
      Get.toNamed(Routes.reset, arguments: {'uid': r.uid, 'token': r.token});
    } catch (e) {
      loading.value = false;
      error.value = e.toString();
      Get.snackbar('OTP failed', error.value!);
    }
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
