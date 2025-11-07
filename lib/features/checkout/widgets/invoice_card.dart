// lib/features/checkout/widgets/invoice_card.dart
import 'package:flutter/material.dart';
import '../widgets/card_shell.dart' as card;
import '../utils/design_tokens.dart';

class InvoiceCard extends StatelessWidget {
  final double orderValue;
  final double redeemedValue;
  final double dueToday;
  final double total;

  const InvoiceCard({
    super.key,
    // MODIFIED: Make fields optional to avoid breaking old static version
    this.orderValue = 0.0,
    this.redeemedValue = 0.0,
    this.dueToday = 0.0,
    this.total = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget row(
        String label,
        String value, {
          Color valueColor = tealHeader,
          bool negative = false,
        }) {
      final displayValue = negative ? ' - $value' : value;
      return Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            displayValue,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: negative ? errorRed : valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              height: 1.4,
            ),
          ),
        ],
      );
    }

    return card.Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitleText('Checkout invoice'),
          const SizedBox(height: 16),

          // --- MODIFIED: Dynamic values ---
          row('Order value', '\$${orderValue.toStringAsFixed(2)}'),
          const SizedBox(height: 12),

          row('Redeemed from balance', '\$${redeemedValue.toStringAsFixed(2)}',
              valueColor: errorRed, negative: true),
          const SizedBox(height: 12),

          row('Due today', '\$${dueToday.toStringAsFixed(2)}'),
          const SizedBox(height: 12),

          Container(height: 1, color: borderHairline),
          const SizedBox(height: 12),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    height: 1.4,
                  ),
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}', // <-- MODIFIED
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// same text style as "Redemption option"
class _SectionTitleText extends StatelessWidget {
  final String text;
  const _SectionTitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
        height: 1.3,
      ),
    );
  }
}