import 'package:flutter/material.dart';
import '../utils/enums.dart';
import '../widgets/card_shell.dart' as card;
import '../utils/design_tokens.dart';

class CreditRedemptionDetailsCard extends StatelessWidget {
  final RedemptionUIState uiState;
  final String availableAmount; // e.g. "11.23"
  final String maxAmount;       // e.g. "6.50"
  final String enteredAmount;   // e.g. "6.50" or ""

  const CreditRedemptionDetailsCard({
    required this.uiState,
    required this.availableAmount,
    required this.maxAmount,
    required this.enteredAmount,
  });

  @override
  Widget build(BuildContext context) {
    final showValue = uiState == RedemptionUIState.filled;
    final hintMode  = uiState == RedemptionUIState.empty;

    return card.Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitleText('Redemption option'),
          const SizedBox(height: 16),

          // Available + Max chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'Available: '),
                    TextSpan(
                      text: '\$$availableAmount',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: maxChipBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Max:',
                      style: TextStyle(
                        color: maxChipLabel,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '\$$maxAmount',
                      style: const TextStyle(
                        color: maxChipValue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Rounded 128 "input"
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(128),
              border: Border.all(color: borderHairline, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.attach_money,
                  size: 20,
                  color: textPrimary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    showValue
                        ? enteredAmount
                        : hintMode
                        ? 'Enter amount'
                        : '', // if switch OFF we never render this card
                    style: TextStyle(
                      color: hintMode
                          ? textSecondary
                          : textPrimary,
                      fontSize: 14,
                      fontWeight:
                      hintMode ? FontWeight.w400 : FontWeight.w400,
                      fontFamily: 'Roboto',
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
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
