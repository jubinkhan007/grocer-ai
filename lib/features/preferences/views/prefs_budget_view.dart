import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shell/main_binding.dart';
import '../../../shell/main_shell.dart';
import '../../home/dashboard_screen.dart';
import '../widgets/next_button.dart';

class SpendingLimitScreen extends StatefulWidget {
  const SpendingLimitScreen({super.key});

  @override
  State<SpendingLimitScreen> createState() => _SpendingLimitScreenState();
}

class _SpendingLimitScreenState extends State<SpendingLimitScreen> {
  /// ===== FIGMA TOKENS =====
  static const _pageBg = Color(0xFFF4F6F6);
  static const _statusTeal = Color(0xFF002C2E); // dark strip behind status bar
  static const _teal = Color(0xFF33595B); // brand teal
  static const _textPrimary = Color(0xFF212121);
  static const _chipBg = Color(0xFFE9E9E9); // default chip bg
  static const _chipSelectedOverlay = Color(0xFFB0BFBF); // screenshot "active" bg
  // ^ In Figma it looks like a desaturated teal/grey. We’ll use #B0BFBF same as
  // other screens where selected chip has that bg.

  final TextEditingController _amountCtrl = TextEditingController();

  // Preset ranges from Figma, in display order.
  final List<String> _ranges = <String>[
    r'$ 50 - 80',
    r'$ 80 - 150',
    r'$ 150 - 200',
    r'$ 200 - 250',
    r'$ 300 - 350',
    r'$ 350 - 400',
    r'$ 400 - 450',
    r'$ 500 - 550',
    r'$ 550 - 600',
  ];

  // Which preset range (if any) is selected
  String? _selectedRange;

  @override
  void initState() {
    super.initState();

    // When user edits text manually, we should clear chip highlight if it
    // doesn't exactly match any preset.
    _amountCtrl.addListener(_handleManualEdit);
  }

  void _handleManualEdit() {
    final currentText = _amountCtrl.text.trim();
    if (currentText != _selectedRange) {
      // user typed something else -> deselect chips
      setState(() {
        _selectedRange = null;
      });
    }
  }

  void _onTapRange(String range) {
    setState(() {
      _selectedRange = range;
      _amountCtrl.text = range.replaceFirst(r'$ ', ''); // Figma shows `$` icon separately in the field, so we store just numbers/range-ish
    });
  }

  bool get _canContinue {
    // You can continue if there's *any* non-empty value in the field.
    return _amountCtrl.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // Match white status icons on dark teal strip
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ));

    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        top: false, // we'll custom paint our own dark status bar background
        bottom: false,
        child: Column(
          children: [
            /// ===== STATUS STRIP =====
            Container(
              color: _statusTeal,
              padding: EdgeInsets.only(
                top: media.padding.top,
                bottom: 8,
                left: 24,
                right: 24,
              ),
              // System status content (time, carrier, battery) is handled by OS;
              // Figma "9:41" etc is just mock.
            ),

            /// ===== PROGRESS STEPS ROW (all 6 teal in this step) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: const [
                  Expanded(child: _StepBar(color: _teal)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(color: _teal)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(color: _teal)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(color: _teal)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(color: _teal)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(color: _teal)),
                ],
              ),
            ),

            /// ===== BODY SCROLL =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Title
                    const Text(
                      'Spending limit per week',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// ===== AMOUNT INPUT PILL =====
                    _AmountField(
                      controller: _amountCtrl,
                    ),

                    const SizedBox(height: 24),

                    /// ===== CHIPS GRID =====
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _ranges.map((range) {
                          final bool selected = _selectedRange == range;

                          return _BudgetChip(
                            label: range,
                            selected: selected,
                            onTap: () => _onTapRange(range),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 200), // space above CTA in scroll
                  ],
                ),
              ),
            ),

            /// ===== CTA (only visible when something entered/selected) =====
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: _canContinue
                  ? Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  media.padding.bottom + 24,
                ),
                child: NextArrowButton(
                  onNext: () {
                    Get.offAll(
                          () => MainShell(),
                      binding: MainBinding(),
                    );
                  },
                ),
              )
                  : SizedBox(height: media.padding.bottom + 24),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    // TODO: Navigate to next onboarding step / submit value
    // Navigator.push(...);
  }
}

/// =========================
/// TOP PROGRESS BAR SEGMENT
/// =========================
class _StepBar extends StatelessWidget {
  final Color color;
  const _StepBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

/// =========================
/// AMOUNT TEXT FIELD PILL
/// (128 radius pill, 16px padding, $ icon on the left)
/// =========================
class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
  });

  final TextEditingController controller;

  static const _teal = Color(0xFF33595B);
  static const _fieldBg = Color(0xFFFEFEFE);
  static const _border = Colors.transparent; // no stroke in Figma, just white bg
  static const _hintColor = Color(0xFF6A6A6A);
  static const _textColor = Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _fieldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(128),
        side: const BorderSide(color: _border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(
              Icons.attach_money_rounded,
              size: 20,
              color: _teal,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(
                    color: _hintColor,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================
/// BUDGET CHIP
///  - height ~40 from design
///  - radius 60
///  - default bg #E9E9E9, text dark
///  - selected bg #B0BFBF (same tone you used for selected chip)
/// =========================
class _BudgetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BudgetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _defaultBg = Color(0xFFE9E9E9);
  static const _selectedBg = Color(0xFFB0BFBF);
  static const _textColor = Color(0xFF212121);
  static const _teal = Color(0xFF33595B);

  @override
  Widget build(BuildContext context) {
    final bg = selected ? _selectedBg : _defaultBg;
    final textStyle = const TextStyle(
      color: _textColor,
      fontSize: 14,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      height: 1.3,
    );

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(60),
      child: InkWell(
        borderRadius: BorderRadius.circular(60),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // In Figma every chip starts with a tiny "$" icon in teal.
              const Icon(
                Icons.attach_money_rounded,
                size: 16,
                color: _teal,
              ),
              const SizedBox(width: 4),
              Text(
                label.replaceFirst(r'$ ', ''), // chips already include $ in mock,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =========================
/// NEXT BUTTON PILL
/// Full-width teal pill at bottom with white arrow "→"
/// radius ~40 / height 56
/// =========================
class _NextButton extends StatelessWidget {
  final VoidCallback onNext;
  const _NextButton({required this.onNext});

  static const _teal = Color(0xFF33595B);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: _teal,
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onNext,
          child: const Center(
            child: _ArrowRightIcon(),
          ),
        ),
      ),
    );
  }
}

/// Simple white arrow icon that matches the Figma CTA
class _ArrowRightIcon extends StatelessWidget {
  const _ArrowRightIcon();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.arrow_forward,
          size: 20,
          color: Colors.white,
        ),
      ],
    );
  }
}
