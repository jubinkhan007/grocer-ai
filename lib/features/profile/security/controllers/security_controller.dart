import 'package:get/get.dart';
import '../services/security_service.dart';

class SecurityController extends GetxController {
  SecurityController(this._service);
  final SecurityService _service;

  final isLoading = false.obs;

  Future<void> updatePassword({
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {
    try {
      isLoading.value = true;
      await _service.changePassword(
        oldPassword: oldPass,
        newPassword: newPass,
        confirmPassword: confirmPass,
      );
      Get.snackbar('Success', 'Password updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password');
    } finally {
      isLoading.value = false;
    }
  }
}
