import 'package:flutter/material.dart';

class NextArrowButton extends StatelessWidget {
  const NextArrowButton({
    super.key,
    required this.onNext,
  });

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: const Color(0xFF33595B),
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onNext,
          child: const Center(
            child: Icon(
              Icons.arrow_forward, // replace with custom arrow asset if you have one
              color: Color(0xFFFEFEFE),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
