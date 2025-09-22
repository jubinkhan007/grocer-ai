import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final current = 0.obs;
  final box = GetStorage();

  final pages = const [
    OnbPage(
      image: 'assets/images/onb_1.png',
      title: 'AI-powered Grocery Shopping',
      subtitle:
          'Let Grocerai create your shopping list based on your customized preferences',
    ),
    OnbPage(
      image: 'assets/images/onb_2.png',
      title: 'Tweak Your List',
      subtitle: 'Easily add, remove, or adjust items to match your needs',
    ),
    OnbPage(
      image: 'assets/images/onb_3.png',
      title: 'Stores Compete for You',
      subtitle:
          'Let grocery stores bid for your order, so you always get the best prices',
    ),
    OnbPage(
      image: 'assets/images/onb_4.png',
      title: 'Find Your Best Deal',
      subtitle:
          'Compare offers from multiple stores and choose the one that fits your budget and preferences',
    ),
    OnbPage(
      image: 'assets/images/onb_5.png',
      title: 'Skip the Store Trip',
      subtitle:
          'Save time, money, and the stress of in-store shopping—get everything delivered at your doorstep',
    ),
  ];

  void onChanged(int i) => current.value = i;

  void next() {
    if (current.value == pages.length - 1) {
      finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() => finish();

  void finish() {
    box.write('seen_onboarding', true);
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnbPage {
  final String image, title, subtitle;
  const OnbPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
