// lib/app/app_routes.dart

import 'package:get/get.dart';
import 'package:grocer_ai/features/splash/splash_view.dart';
import 'package:grocer_ai/features/onboarding/onboarding_binding.dart';
import 'package:grocer_ai/features/onboarding/onboarding_view.dart';
import 'package:grocer_ai/features/auth/forgot_password/forgot_bindings.dart';
import 'package:grocer_ai/features/auth/forgot_password/forgot_view.dart';
import 'package:grocer_ai/features/auth/forgot_password/otp_view.dart';
import 'package:grocer_ai/features/auth/forgot_password/reset_view.dart';
import 'package:grocer_ai/features/auth/login/login_binding.dart';
import 'package:grocer_ai/features/auth/login/login_view.dart';
import 'package:grocer_ai/features/auth/signup_bidning.dart';
import 'package:grocer_ai/features/auth/signup_view.dart';

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
  static const main = '/main';
  static const forgot = '/forgot';
  static const otp = '/forgot/otp';
  static const reset = '/forgot/reset';
}

class AppPages {
  static final pages = <GetPage>[
    // ✅ ADD THESE
    GetPage(name: Routes.splash, page: () => const SplashView()),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),

    // Auth
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

    // Forgot flow
    GetPage(
      name: Routes.forgot,
      page: () => const ForgotView(),
      binding: ForgotBinding(),
    ),
    GetPage(
      name: Routes.otp,
      page: () => const OtpView(),
      binding: ForgotBinding(),
    ),
    GetPage(
      name: Routes.reset,
      page: () => const ResetView(),
      binding: ForgotBinding(),
    ),
  ];
}
