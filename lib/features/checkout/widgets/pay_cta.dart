import 'package:flutter/material.dart';

import '../utils/design_tokens.dart';

class PayCTA extends StatelessWidget {
  final VoidCallback onTap;
  const PayCTA({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
              onTap: onTap,
              child: const Center(
                child: Text(
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
