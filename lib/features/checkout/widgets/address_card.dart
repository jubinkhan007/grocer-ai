import 'package:flutter/material.dart';
import 'package:grocer_ai/features/checkout/widgets/section_header.dart';
import '../widgets/card_shell.dart' as card;
import '../utils/design_tokens.dart';

class AddressCard extends StatelessWidget {
  final String address;
  final VoidCallback onChange;

  const AddressCard({
    required this.address,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return card.Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderRow(
            title: 'Delivery address',
            actionLabel: 'Change',
            onAction: onChange,
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: borderHairline),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: tealHeader,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
