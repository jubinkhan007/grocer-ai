// lib/features/onboarding/location/location_denied_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/onboarding/location/location_controller.dart';

// Design Tokens from your other location screen
const _bg = Color(0xFFF1F4F6);
const _teal = Color(0xFF0C3E3D);
const _text = Color(0xFF33363E);
const _sub = Color(0xFF6B737C);

class LocationDeniedView extends StatelessWidget {
  const LocationDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the same LocationController
    final c = Get.find<LocationController>();
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header arc + illustration from your image
            Stack(
              children: [
                Container(height: 156, color: _bg),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(w, 170),
                        bottomRight: Radius.elliptical(w, 170),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      // Using the illustration from your image
                      child: Image.asset(
                        'assets/images/illus_location_card.png',
                        width: 210,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Title + subtitle from your image
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Turn on device location",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "We require your precise location to seamlessly connect "
                        "you to nearby service providers.",
                    style: TextStyle(fontSize: 18, color: _sub, height: 1.35),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Please turn on device location.",
                    style: TextStyle(fontSize: 18, color: _text, height: 1.35),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(44),
                      ),
                    ),
                    // "Try again" button calls the permission request logic again
                    onPressed: c.loading.value
                        ? null
                        : c.requestAndSaveLocation,
                    child: c.loading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Try again',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}