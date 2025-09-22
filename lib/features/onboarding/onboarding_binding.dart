import 'package:get/get.dart';
import 'package:grocer_ai/features/auth/login_binding.dart'; // Import LoginBinding
import 'onboarding_controller.dart';
import '../../app/app_routes.dart';
import 'onboarding_view.dart';
import '../auth/login_view.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}

class OnboardingPages {
  static final routes = <GetPage>[
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    // Add the LoginBinding here
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
