// lib/features/splash/splash_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Keep GetStorage for onboarding check
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import '../../app/app_routes.dart';
import '../auth/auth_controller.dart'; // <-- Import AuthController

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // Get the AuthController instance (it should be ready from AppBindings)
  final AuthController authController = Get.find<AuthController>();
  final box = GetStorage(); // Keep for onboarding check

  @override
  void initState() {
    super.initState();
    // status-bar strip color like the mock
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        //statusBarColor: _topTeal, // Assuming _topTeal is defined if needed
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    Timer(const Duration(milliseconds: 1400), () {
      // ---- MODIFIED LOGIC ----
      // Check the centralized authentication state
      print("Splash Timer Fired: Checking authController.isAuthenticated = ${authController.isAuthenticated.value}"); // Debug log

      if (authController.isAuthenticated.value) {
        print("Splash: Authenticated, navigating to Routes.main"); // Debug log
        Get.offAllNamed(Routes.main); // Navigate to the main app shell (home/dashboard etc.)
      } else {
        // If not authenticated, proceed with the onboarding/login check
        final seenOnboarding = box.read('seen_onboarding') ?? false;
        print("Splash: Not Authenticated. Seen Onboarding=$seenOnboarding. Navigating to ${seenOnboarding ? Routes.login : Routes.onboarding}"); // Debug log
        Get.offAllNamed(seenOnboarding ? Routes.login : Routes.onboarding);
      }
      // ---- END MODIFIED LOGIC ----
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F6),
      // Center in the *entire* screen, not within SafeArea
      body: Center(
        child: SvgPicture.asset(
          'assets/images/grocerai_3.svg',  // Use the SVG asset here
          width: size.width * 0.65, // tweak if you want it larger/smaller
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

const _topTeal = Color(0xFF0C3E3D);
