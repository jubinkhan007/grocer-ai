import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    // status-bar strip color like the mock
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        //statusBarColor: _topTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    Timer(const Duration(milliseconds: 1400), () {
      final seen = box.read('seen_onboarding') == true;
      Get.offAllNamed(seen ? Routes.login : Routes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F6), // same as onboarding bg
      body: SafeArea(
        //top: false, // let teal status bar show at top
        child: Stack(
          children: [
            // Logo anchored ~bottom as per Figma (use Align + Padding)
            Align(
              alignment: const Alignment(0, 0.75),
              child: Image.asset(
                'assets/images/logo_grocerai.png', // your logo
                width: MediaQuery.of(context).size.width * 0.75,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _topTeal = Color(0xFF0C3E3D);
