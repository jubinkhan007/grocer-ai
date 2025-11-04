// lib/widgets/complete_preference_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletePreferenceDialog extends StatelessWidget {
  const CompletePreferenceDialog({
    super.key,
    required this.percent,              // 0.0 → 1.0 (e.g., 0.40)
    required this.onEdit,
    required this.onSkip,
    this.onClose,
    this.width = 382,                   // Figma width
  });

  final double percent;
  final double width;
  final VoidCallback onEdit;
  final VoidCallback onSkip;
  final VoidCallback? onClose;

  // Figma colors
  static const _teal = Color(0xFF33595B);
  static const _nearWhite = Color(0xFFFEFEFE);
  static const _textPrimary = Color(0xFF4D4D4D);
  static const _barBg = Color(0xFFE6EAEB);
  static const _warnStroke = Color(0xFFA64825);
  static const _warnBg = Color(0x19EF4D75); // 10% tint as in Figma

  @override
  Widget build(BuildContext context) {
    // clamp progress
    final p = percent.clamp(0.0, 1.0);
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: width,
          padding: const EdgeInsets.all(24),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Title + Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Complete your preference',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  InkWell(
                    onTap: onClose ?? () => Get.back(),
                    borderRadius: BorderRadius.circular(20),
                    child: const SizedBox(
                      width: 24, height: 24,
                      child: Icon(Icons.close_rounded, size: 24, color: _textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress + % text (exact 8px height, rounded)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(color: _barBg),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: p,
                              child: Container(color: _teal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(p * 100).round()}%',
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Warning card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: ShapeDecoration(
                  color: _warnBg,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: _warnStroke),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // warning icon placeholder (kept minimal per Figma)
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0, right: 12),
                      child: Icon(Icons.warning_amber_rounded,
                          size: 20, color: _warnStroke),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Warning',
                            style: TextStyle(
                              color: _warnStroke,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please complete your preferences to receive a personalized grocery list tailored to needs.',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Buttons row
              Row(
                children: [
                  // Skip (outlined, pill 56px)
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: onSkip,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _teal, width: 1),
                          shape: const StadiumBorder(),
                          foregroundColor: _teal,
                          textStyle: const TextStyle(
                            fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Edit (filled, pill 56px)
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _teal,
                          foregroundColor: _nearWhite,
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
