import 'package:flutter/material.dart';
import '../widgets/card_shell.dart' as card;
import '../utils/design_tokens.dart';

class CreditRedemptionToggleCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const CreditRedemptionToggleCard({
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return card.Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Credit Redemption',
            style: TextStyle(
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
              height: 1.4,
            ),
          ),
          Transform.scale(
            scale: 0.9, // iOS-style compact thumb in screenshots
            child: Switch(
              value: enabled,
              activeColor: Colors.white,
              activeTrackColor: tealHeader,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
