// lib/features/checkout/widgets/add_payment_method_card.dart

import 'package:flutter/material.dart';
import '../widgets/card_shell.dart' as card;
import '../utils/design_tokens.dart';

class AddPaymentMethodCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddPaymentMethodCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return card.Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Row(
          children: const [
            Icon(Icons.add, size: 20, color: textPrimary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add payment method',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
