import 'package:flutter/material.dart';

class ProgressDots extends StatelessWidget {
  final int length;
  final int index;
  const ProgressDots({super.key, required this.length, required this.index});

  @override
  Widget build(BuildContext context) {
    final active = Theme.of(context).colorScheme.primary;
    final inactive = const Color(0xFFB9C4C6);

    return Row(
      children: List.generate(length, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 6,
          width: isActive ? 24 : 6,
          decoration: BoxDecoration(
            color: isActive ? active.withOpacity(.9) : inactive.withOpacity(.7),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
