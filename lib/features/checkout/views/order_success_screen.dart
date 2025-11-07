// lib/features/checkout/views/order_success_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart';
import 'package:intl/intl.dart';

import '../../../shell/main_shell_controller.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- MODIFIED: Get the Order object passed as an argument ---
    final Order? order = (Get.arguments is Order) ? Get.arguments as Order : null;

    // Format delivery time (assuming API sends a parsable date)
    String deliveryTime = "later today";
    if (order != null) {
      try {
        deliveryTime =
        "by ${DateFormat('h:mm a \'on\' MMMM d, y').format(order.createdAt.add(const Duration(hours: 3)))}";
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Congratulations Card at the center
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEFEFE),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFE6EAEB),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Award Badge
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset('assets/images/award_badge.png'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Congratulations!!',
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                // --- MODIFIED: Dynamic Text ---
                Text(
                  'You saved \$${order?.discount ?? '0.00'} with GrocerAI today!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your order #${order?.orderId ?? '...'} totals \$${order?.price ?? '0.00'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your order will arrive $deliveryTime',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Review',
                    onTap: () {
                      // TODO: Navigate to Review Screen
                      Get.snackbar('Coming Soon', 'Review flow not implemented.');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionButton(
                    label: 'Refer',
                    onTap: () {
                      // Navigate to Home, then open Referral
                      Get.offAllNamed(Routes.main);
                      Get.find<MainShellController>().openReferral();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionButton(
                    label: 'Start over',
                    onTap: () {
                      // Navigate to Home, then open New Order
                      Get.offAllNamed(Routes.main);
                      Get.toNamed(Routes.order); // (This will go to NewOrderScreen)
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- MODIFIED: Return to Home Button ---
          GestureDetector(
            onTap: () => Get.offAllNamed(Routes.main), // <-- WIRED UP
            child: Container(
              width: 382,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: const Color(0xFF33595B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1915224F),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  'Return to the Home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for the 3 small action buttons
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFF33595B),
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1915224F),
              blurRadius: 16,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF33595B),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}