import 'package:flutter/material.dart';

import '../utils/design_tokens.dart';

class Card extends StatelessWidget {
  final Widget child;
  const Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
