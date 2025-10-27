// lib/app/app_routes.dart

import 'package:get/get.dart';
import 'package:grocer_ai/features/home/home_binding.dart';
import 'package:grocer_ai/features/home/dashboard_screen.dart';
import 'package:grocer_ai/features/onboarding/location/location_binding.dart';
import 'package:grocer_ai/features/onboarding/location/location_permission_view.dart';
import 'package:grocer_ai/features/preferences/preferences_binding.dart';
import 'package:grocer_ai/features/preferences/views/prefs_budget_view.dart';
import 'package:grocer_ai/features/preferences/views/prefs_cuisine_view.dart';
import 'package:grocer_ai/features/preferences/views/prefs_diet_view.dart';
import 'package:grocer_ai/features/preferences/views/prefs_frequency_view.dart';
import 'package:grocer_ai/features/preferences/views/prefs_grocers_view.dart';
import 'package:grocer_ai/features/preferences/views/prefs_household_view.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_screen.dart';
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

import '../features/help/views/help_support_screen.dart';
import '../features/offer/views/offer_screen.dart';
import '../features/orders/views/orders_screen.dart';
import '../features/profile/security/views/security_screen.dart';
import '../features/profile/settings/settings_screen.dart';
import '../features/profile/transactions/transactions_screen.dart';
import '../shell/main_shell.dart';
import '../shell/main_shell_controller.dart';

abstract class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const cart = '/cart';
  static const compare = '/compare';
  static const checkout = '/checkout';
  static const locationPermission = '/locationPermission';
  static const orders = '/orders';
  static const profile = '/profile';
  static const main = '/shell';
  static const forgot = '/forgot';
  static const otp = '/forgot/otp';
  static const reset = '/forgot/reset';
  static const prefsStart = '/prefs';
  static const prefsGrocers = '/prefs/grocers';
  static const prefsHouse = '/prefs/household';
  static const prefsDiet = '/prefs/diet';
  static const prefsCuisine = '/prefs/cuisine';
  static const prefsFreq = '/prefs/frequency';
  static const prefsBudget = '/prefs/budget';
  static const offer = '/offer';
  static const order = '/order';
  static const help = '/help';
  static const wallet = '/profile/wallet';
  static const transactions = '/profile/transactions';
  static const livechat = '/profile/livechat';
  static const security = '/profile/security';
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

    GetPage(
      name: Routes.locationPermission,
      page: () => const LocationPermissionView(),
      binding: LocationPermissionBinding(),
    ),

    GetPage(
      name: Routes.prefsGrocers,
      page: () => const PrefsGrocersView(),
      binding: PreferencesBinding(),
    ),
    GetPage(
      name: Routes.prefsHouse,
      page: () => const PrefsHouseholdView(),
      binding: PreferencesBinding(),
    ),
    GetPage(
      name: Routes.prefsDiet,
      page: () => const PrefsDietView(),
      binding: PreferencesBinding(),
    ),
    GetPage(
      name: Routes.prefsCuisine,
      page: () => const PrefsCuisineView(),
      binding: PreferencesBinding(),
    ),
    GetPage(
      name: Routes.prefsFreq,
      page: () => const PrefsFrequencyView(),
      binding: PreferencesBinding(),
    ),
    GetPage(
      name: Routes.prefsBudget,
      page: () => const PrefsBudgetView(),
      binding: PreferencesBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => DashboardScreen(),
      binding: HomeBinding(),
    ),
    GetPage(name: Routes.main, page: () => MainShell(), binding: BindingsBuilder(() {
      Get.put(MainShellController());
    })),
    GetPage(name: Routes.offer, page: () => const OfferScreen()),
    GetPage(name: Routes.order,     page: () => const OrderScreen()),
    GetPage(name: Routes.help,     page: () => const HelpSupportScreen()),
    GetPage(name: Routes.profile,  page: () => const SettingsScreen()),
    GetPage(
      name: Routes.wallet,
      page: () => WalletScreen(),
      //binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.transactions,
      page: () => TransactionsScreen(),
      //binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.security,
      page: () => SecurityScreen(),
      //binding: HomeBinding(),
    ),
  ];
}
