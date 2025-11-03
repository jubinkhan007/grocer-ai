import 'package:flutter/material.dart';
import '../widgets/card_shell.dart' as card;
import '../utils/design_tokens.dart';

class TimingCard extends StatelessWidget {
  final String selectedSlot;
  final ValueChanged<String> onSelect;

  const TimingCard({
    required this.selectedSlot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final slots = const [
      '10 AM - 11 AM',
      '11 AM - 12 PM',
      '12 PM - 1 PM',
      '1 PM - 2 PM',
      '2 PM - 3 PM',
      '3 PM - 4 PM',
      '4 PM - 5 PM',
      '5 PM - 6 PM',
      '6 PM - 7 PM',
      '7 PM - 8 PM',
    ];

    Widget slotTile(String label) {
      final isSel = label == selectedSlot;
      return GestureDetector(
        onTap: () => onSelect(label),
        child: Container(
          width: 168, // matches Figma 2-col layout on 430 canvas
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: borderCard,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    height: 1.4,
                  ),
                ),
              ),
              _RadioCircle(selected: isSel),
            ],
          ),
        ),
      );
    }

    return card.Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitleText('Timing'),
          const SizedBox(height: 16),
          Container(height: 1, color: borderHairline),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final s in slots) slotTile(s),
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