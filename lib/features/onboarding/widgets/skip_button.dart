import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../onboarding_controller.dart';

class SkipButton extends GetView<OnboardingController> {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: controller.skip,
      icon: const SizedBox.shrink(),
      label: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SKIP',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, color: Colors.black),
        ],
      ),
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    );
  }
}
