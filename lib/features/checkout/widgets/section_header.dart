import 'package:flutter/material.dart';

import '../utils/design_tokens.dart';

class SectionHeaderRow extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeaderRow({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              height: 1.3,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: linkTeal,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                height: 1.3,
              ),
            ),
          ),
      ],
    );
  }
}
