import 'package:get/get.dart';
import 'package:grocer_ai/features/auth/login_binding.dart';
import 'package:grocer_ai/features/auth/login_view.dart';
import 'package:grocer_ai/features/auth/signup_bidning.dart';
import 'package:grocer_ai/features/auth/signup_view.dart';
// import '../features/auth/views/splash_view.dart';
// import '../features/auth/views/login_view.dart';
// import '../features/home/views/home_view.dart';
// import '../features/cart/views/cart_view.dart';
// import '../features/compare_bid/views/compare_view.dart';
// import '../features/checkout/views/checkout_view.dart';
// import '../features/orders/views/orders_view.dart';
// import '../features/profile/views/profile_view.dart';

abstract class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const cart = '/cart';
  static const compare = '/compare';
  static const checkout = '/checkout';
  static const orders = '/orders';
  static const profile = '/profile';
}

class AppPages {
  static final pages = <GetPage>[
    // GetPage(name: Routes.splash,   page: () => const SplashView()),
    // GetPage(name: Routes.login,    page: () => const LoginView()),
    // GetPage(name: Routes.home,     page: () => const HomeView()),
    // GetPage(name: Routes.cart,     page: () => const CartView()),
    // GetPage(name: Routes.compare,  page: () => const CompareView()),
    // GetPage(name: Routes.checkout, page: () => const CheckoutView()),
    // GetPage(name: Routes.orders,   page: () => const OrdersView()),
    // GetPage(name: Routes.profile,  page: () => const ProfileView()),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
  ];
}
