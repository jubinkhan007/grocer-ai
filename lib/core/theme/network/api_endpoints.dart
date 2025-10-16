// lib/core/theme/network/api_endpoints.dart
class ApiEnv {
  static const String scheme = 'http';
  static const String host = '45.88.223.47';
  static const int port = 8000;

  static String get base => '$scheme://$host:$port';
}

class ApiPath {
  static const String v1 = '/api/v1';
  static const String auth = '$v1/auth';

  // Login
  static const String login = '$auth/login/'; // POST

  // Forgot Password (from Swagger screenshots)
  static const String pwReset = '$auth/password-reset/'; // POST {email}
  static const String pwOtpVerify =
      '$auth/password-reset/otp-verify/'; // POST {email, code}
  static const String pwConfirm =
      '$auth/password-reset/confirm/'; // POST {password, confirm_password, uid, token}

  static const String refresh = '$auth/refresh/'; // (future)

  static const String register = '$auth/register/';
  static const String preferences = '/api/v1/preferences/'; // GET (paginated)
  static const String userPreferences =
      '/api/v1/user-preferences/'; // POST per screen
  static const profilePersonalInfo = '/api/v1/profile/personal-info/';
  static const profilePartners = '/api/v1/profile/partners/';
  static const profileReferrals = '/api/v1/profile/referrals/';
  static const notifications = '/api/v1/notifications/';
  static const dashboardPreferences = '/api/v1/profile/dashboard-preferences/';
  static const passwordChange = '/api/v1/auth/password-change/';
}
