import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/core/theme/themes.dart';
import 'package:grocer_ai/features/auth/login_binding.dart';
import 'package:grocer_ai/features/auth/login_view.dart';
import 'package:grocer_ai/features/onboarding/onboarding_binding.dart';
import 'package:grocer_ai/features/splash/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const GrocerAiApp());
}

class GrocerAiApp extends StatelessWidget {
  const GrocerAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GrocerAI',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: Routes.splash,
      getPages: [
        GetPage(name: Routes.splash, page: () => const SplashView()),
        ...OnboardingPages.routes,
        GetPage(
          name: Routes.login,
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),
      ],
    );
  }
}
