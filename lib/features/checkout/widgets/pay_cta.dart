// lib/features/checkout/widgets/pay_cta.dart
import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';

class PayCTA extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading; // <-- NEW

  const PayCTA({
    required this.onTap,
    this.isLoading = false, // <-- NEW
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16), // Added bottom padding
        color: Colors.transparent,
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: Material(
            color: tealHeader,
            borderRadius: BorderRadius.circular(100),
            elevation: 0,
            shadowColor: shadowPill,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: isLoading ? null : onTap, // <-- MODIFIED
              child: Center(
                // --- MODIFIED: Show loader or text ---
                child: isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : const Text(
                  'Proceed to pay',
                  style: TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}