import 'package:flutter/material.dart';

import '../utils/design_tokens.dart';

class CheckoutHeader extends StatelessWidget {
  final VoidCallback onBack;
  const CheckoutHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // dark status strip
        Container(
          width: double.infinity,
          color: tealStatus,
          child: SafeArea(
            bottom: false,
            child: const SizedBox(height: 0),
          ),
        ),

        // teal app bar
        Container(
          width: double.infinity,
          color: tealHeader,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: onBack,
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Color(0xFFFEFEFE),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Checkout',
                  style: TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    height: 1.2,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
