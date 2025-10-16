import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final _box = GetStorage();
  final isLoggingOut = false.obs;

  Future<void> logout() async {
    try {
      isLoggingOut.value = true;

      // Clear only what you need. Token key must match your interceptor usage.
      _box.remove('auth_token');
      _box.remove('user'); // optional

      // If you keep any in-memory state/controllers, dispose here if needed.

      // Navigate to auth flow (replace with your route)
      Get.offAllNamed('/login');  // or Get.offAll(() => const LoginScreen());
    } finally {
      isLoggingOut.value = false;
    }
  }
}
