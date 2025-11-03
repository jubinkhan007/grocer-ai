import 'package:flutter/material.dart';
import '../widgets/card_shell.dart' as card;
import '../utils/design_tokens.dart';

class FulfillmentMethodCard extends StatelessWidget {
  final String selected; // 'pickup' or 'delivery'
  final ValueChanged<String> onSelect;

  const FulfillmentMethodCard({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    Widget pill(String value, String label) {
      final isSel = selected == value;
      return GestureDetector(
        onTap: () => onSelect(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(60),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RadioCircle(selected: isSel),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return card.Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitleText('Get Stuffs by'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              pill('pickup', 'Store pickup'),
              pill('delivery', 'Home delivery'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool selected;
  const _RadioCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 2,
          color: selected ? tealHeader : borderCard,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: tealHeader,
          shape: BoxShape.circle,
        ),
      )
          : const SizedBox.shrink(),
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
