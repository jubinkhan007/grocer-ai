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
  static const String profileLocations = '/api/v1/profile/locations/';
  static const products = '/api/v1/products/';
  // --- NEW ORDER PREFERENCES ---
  static const String orderPreferenceList = '/api/v1/order-preference-list/';
  static const String orderPreferences = '/api/v1/order-preferences/';

  // order-items
  static const relatedProducts = '/api/v1/related-products/';

  // Order History
  static const String orders = '/api/v1/orders/'; // GET, POST
  static const String orderDetail = '/api/v1/orders/'; // /{id}/ GET, PUT, PATCH
  static const String orderLastActive = '/api/v1/orders/last-active/'; // GET
  static const String orderStatus = '/api/v1/order-status/'; // GET

  // Checkout
  static const String timeSlots = '/api/v1/time-slots/'; // GET
  static const String paymentMethods = '/api/v1/payment-methods/'; // GET (Types)
  static const String userPaymentMethods =
      '/api/v1/user-payment-methods/'; // GET, POST (User's saved cards)
  static const String userPaymentMethodDetail =
      '/api/v1/user-payment-methods/'; // /{id}/ PUT, PATCH, DELETE
  static const String orderPay = '/api/v1/order-pay/'; // POST

  // media upload
  static const String mediaUpload = '/api/v1/media/';

  // --- NEW: COMPARE/BID ---
  static const String compareGrocery = '/api/v1/compare-grocery/'; // GET
  static const String bidGrocery = '/api/v1/bid-grocery/'; // GET (for rebid)
}
