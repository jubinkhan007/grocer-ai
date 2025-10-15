import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

const _teal = Color(0xFF0C3E3D);

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        title: const Text(
          'GrocerAI',
          style: TextStyle(color: _teal, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: _teal),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_basket_outlined, size: 72, color: _teal),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                'Welcome, ${controller.username.value} 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is your dummy Home screen.\nWire your real dashboard here.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
