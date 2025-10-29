import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ai/features/preferences/views/prefs_cuisine_view.dart';

import '../widgets/next_button.dart';

class DietaryPreferenceScreen extends StatefulWidget {
  const DietaryPreferenceScreen({super.key});

  @override
  State<DietaryPreferenceScreen> createState() =>
      _DietaryPreferenceScreenState();
}

class _DietaryPreferenceScreenState extends State<DietaryPreferenceScreen> {
  /// ===== FIGMA TOKENS / CONSTANTS =====
  static const _pageBg = Color(0xFFF4F6F6); // screen background
  static const _statusTeal = Color(0xFF002C2E); // very top strip
  static const _teal = Color(0xFF33595B); // brand teal
  static const _textPrimary = Color(0xFF212121); // main black-ish text
  static const _textSecondary = Color(0xFF4D4D4D); // helper text
  static const _borderGrey = Color(0xFFE9E9E9); // pill border
  static const _stepInactive = Color(0xFFBABABA);

  // Dietary options from Figma in order
  final List<String> _options = const [
    'Non-Veg',
    'Vegan',
    'Pescatarian',
    'Vegetarian',
  ];

  // which options are checked
  final Set<String> _selected = {'Vegan', 'Vegetarian'};

  final TextEditingController _extraCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set light icons (white) on dark teal status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ));
    _extraCtrl.addListener(_onChangeAny);
  }

  @override
  void dispose() {
    _extraCtrl.dispose();
    super.dispose();
  }

  void _onChangeAny() {
    // just to rebuild the button enable state if user adds text
    setState(() {});
  }

  void _toggle(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  bool get _canContinue =>
      _selected.isNotEmpty || _extraCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: _pageBg,

      /// Sticky bottom CTA pill (matches Figma 56px high, radius ~40)
      bottomNavigationBar: _canContinue
          ? Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          24 + media.padding.bottom,
        ),
        child: SizedBox(
          height: 56,
          child: Material(
            color: _teal,
            borderRadius: BorderRadius.circular(40),
            child: NextArrowButton(
              onNext: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CuisinePreferenceScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      )
          : null,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// ===== TOP STRIP (dark teal behind OS status indicators) =====
          Container(
            color: _statusTeal,
            padding: EdgeInsets.only(
              top: media.padding.top,
              bottom: 8,
              left: 24,
              right: 24,
            ),
            // We do NOT draw time / signal manually in Flutter runtime.
            // System UI handles that here.
          ),

          /// ===== STEP PROGRESS ROW =====
          ///
          /// In this screen, first *three* bars are teal because we're on step 3.
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
                Expanded(child: _StepBar(color: _stepInactive)),
                SizedBox(width: 8),
                Expanded(child: _StepBar(color: _stepInactive)),
                SizedBox(width: 8),
                Expanded(child: _StepBar(color: _stepInactive)),
              ],
            ),
          ),

          /// ===== BODY SCROLL =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- Title ---
                  Text(
                    'Dietary preference',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// --- Option cards ---
                  Column(
                    children: [
                      for (final label in _options) ...[
                        _DietCard(
                          label: label,
                          checked: _selected.contains(label),
                          onTap: () => _toggle(label),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// --- "Additional Information" label ---
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// --- pill text field (56px tall, radius 128, 1px #E9E9E9) ---
                  _AdditionalInfoField(
                    controller: _extraCtrl,
                  ),

                  const SizedBox(height: 120), // spacer so content
                  // doesn't hide under the sticky button when scrolling
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// STEP BAR (4px tall rounded rect)
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

/// ============================================================================
/// SINGLE DIET CARD
///
/// White rounded 8px, padding horiz 24 / vert 20
/// Row: [checkbox 24x24] + 12 + label (16 / 400 / #212121)
class _DietCard extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;

  static const _cardBg = Color(0xFFFEFEFE);
  static const _textPrimary = Color(0xFF212121);
  static const _teal = Color(0xFF33595B);

  const _DietCard({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cardBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              _DietCheckbox(checked: checked),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square checkbox from Figma:
/// - 24x24
/// - radius ~4
/// - unchecked: border 2px teal, transparent fill
/// - checked: teal fill, white checkmark inside
class _DietCheckbox extends StatelessWidget {
  final bool checked;
  const _DietCheckbox({required this.checked});

  static const _teal = Color(0xFF33595B);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: checked ? _teal : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _teal,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: checked
          ? const Icon(
        Icons.check,
        color: Colors.white,
        size: 18,
      )
          : const SizedBox.shrink(),
    );
  }
}

/// ============================================================================
/// ADDITIONAL INFO FIELD
///
/// pill radius 128
/// 1px border #E9E9E9
/// hint color #6A6A6A
/// prefix basket icon in teal (#33595B)
class _AdditionalInfoField extends StatelessWidget {
  final TextEditingController controller;
  const _AdditionalInfoField({required this.controller});

  static const _borderGrey = Color(0xFFE9E9E9);
  static const _hintGrey = Color(0xFF6A6A6A);
  static const _teal = Color(0xFF33595B);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: _teal, // actual typed text color (can be _textPrimary if preferred)
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        height: 1.3,
      ),
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // pill outline
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(128),
          borderSide: const BorderSide(color: _borderGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(128),
          borderSide: const BorderSide(color: _borderGrey, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Icon(
            Icons.shopping_basket_outlined, // basket-ish icon
            color: _teal,
            size: 24,
          ),
        ),
        // remove default prefixIcon padding from Material
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        hintText: 'Enter your dietary preference',
        hintStyle: const TextStyle(
          color: _hintGrey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          height: 1.3,
        ),
      ),
    );
  }
}

/// ============================================================================
/// Arrow icon inside the bottom CTA pill
/// (simple white right arrow, thin line, 24px-ish width in screenshot)
class _ArrowRightIcon extends StatelessWidget {
  const _ArrowRightIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_right_alt_rounded,
      color: Colors.white,
      size: 32,
    );
  }
}
