// lib/features/auth/auth_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/app_routes.dart'; // Make sure Routes are accessible
// Import DioClient if you need to clear its token header on logout
import '../../core/theme/network/dio_client.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  final isLoggingOut = false.obs;

  // ---- NEW: Observable Authentication State ----
  final RxBool isAuthenticated = false.obs;
  // ---- END NEW ----

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus(); // Check status immediately when the app/controller initializes
    print("AuthController onInit: isAuthenticated = ${isAuthenticated.value}"); // Debug log
  }

  void _checkAuthStatus() {
    final token = box.read('auth_token');
    // Check if the token exists and is not empty
    isAuthenticated.value = token != null && token.toString().isNotEmpty;
    print("Checked auth status: Token='${token}', isAuthenticated=${isAuthenticated.value}"); // Debug log
  }

  // --- Call this from LoginController/SignUpController on successful login/signup ---
  void loginSuccess(String accessToken, String refreshToken) {
    box.write('auth_token', accessToken);
    box.write('refresh_token', refreshToken);
    _injectTokenIntoDio(accessToken); // Make sure Dio client has the token immediately
    isAuthenticated.value = true;
    print("Login Success: Set isAuthenticated = true"); // Debug log
    // No navigation here, let the calling controller handle navigation
  }

  Future<void> logout() async {
    try {
      isLoggingOut.value = true;
      box.remove('auth_token');
      box.remove('refresh_token'); // Also remove refresh token if you use it
      box.remove('user'); // Clear any cached user data if needed
      isAuthenticated.value = false; // Update state
      print("Logout: Set isAuthenticated = false"); // Debug log
      _clearTokenFromDio(); // Clear token from Dio client instance

      // Navigate to auth flow
      Get.offAllNamed(Routes.login);
    } finally {
      isLoggingOut.value = false;
    }
  }

  // --- Helper to update Dio Client if it's already initialized ---
  void _injectTokenIntoDio(String token) {
    try {
      // Ensure DioClient is registered and find it
      if (Get.isRegistered<DioClient>()) {
        final dioClient = Get.find<DioClient>();
        dioClient.dio.options.headers['Authorization'] = 'Bearer $token';
        print("Injected token into DioClient"); // Debug log
      } else {
        print("DioClient not registered yet during token injection."); // Debug log
      }
    } catch (e) {
      print("Error finding/updating DioClient during login: $e"); // Handle error
    }
  }

  void _clearTokenFromDio() {
    try {
      // Ensure DioClient is registered and find it
      if (Get.isRegistered<DioClient>()) {
        final dioClient = Get.find<DioClient>();
        dioClient.dio.options.headers.remove('Authorization');
        print("Cleared token from DioClient"); // Debug log
      } else {
        print("DioClient not registered yet during token clearing."); // Debug log
      }
    } catch (e) {
      print("Error finding/clearing DioClient token during logout: $e"); // Handle error
    }
  }
}