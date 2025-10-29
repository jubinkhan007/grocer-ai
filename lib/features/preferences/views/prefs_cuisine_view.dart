import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ai/features/preferences/views/prefs_frequency_view.dart';

import '../widgets/next_button.dart';

class CuisinePreferenceScreen extends StatefulWidget {
  const CuisinePreferenceScreen({super.key});

  @override
  State<CuisinePreferenceScreen> createState() =>
      _CuisinePreferenceScreenState();
}

class _CuisinePreferenceScreenState extends State<CuisinePreferenceScreen> {
  /// ===== FIGMA TOKENS =====
  static const _pageBg = Color(0xFFF4F6F6);
  static const _statusTeal = Color(0xFF002C2E); // strip behind system status bar
  static const _teal = Color(0xFF33595B);
  static const _textPrimary = Color(0xFF212121);
  static const _textSecondary = Color(0xFF6A6A6A);
  static const _cardBg = Color(0xFFFEFEFE);
  static const _dividerGrey = Color(0xFFE9E9E9);
  static const _stepInactive = Color(0xFFBABABA);

  // cuisines = checkbox list
  final List<_CuisineItem> _items = [
    _CuisineItem('indian', 'Indian'),
    _CuisineItem('chinese', 'Chinese'),
    _CuisineItem('texmex', 'Tex-Mex'),
    _CuisineItem('american', 'American'),
  ];

  // free text
  final TextEditingController _extraController = TextEditingController();

  bool get _hasSelection =>
      _items.any((c) => c.selected); // toggles CTA visibility

  void _toggleCuisine(_CuisineItem item) {
    setState(() {
      item.selected = !item.selected;
    });
  }

  @override
  void dispose() {
    _extraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Light text/icons on the dark status bar background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ));

    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        top: false, // we draw our own dark strip under status bar
        child: Column(
          children: [
            /// ===== STATUS STRIP =====
            Container(
              color: _statusTeal,
              height: media.padding.top,
            ),

            /// ===== CONTENT =====
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight -
                            (_hasSelection ? 80 : 0), // leave space for CTA
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// --- step progress row (6 rounded bars)
                          _StepProgressRow(
                            activeCount: 4, // Cuisine = step 4 of 6 in Figma
                            totalCount: 6,
                          ),
                          const SizedBox(height: 24),

                          /// --- Title
                          Center(
                            child: Text(
                              'Cuisine preference',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// --- List of cuisine cards
                          Column(
                            children: [
                              for (final item in _items) ...[
                                _CuisineCard(
                                  label: item.label,
                                  selected: item.selected,
                                  onTap: () => _toggleCuisine(item),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// --- Additional Information
                          const Text(
                            'Additional Information',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 12),

                          _AdditionalInfoField(
                            controller: _extraController,
                            hint: 'Enter your cuisine preference',
                          ),

                          // spacer to push content up so bottom CTA
                          // doesn't overlap content on short screens
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// ===== Bottom CTA pill (arrow only) =====
            if (_hasSelection) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  24 + media.padding.bottom,
                ),
                child: NextArrowButton(
                  onNext: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShoppingFrequencyScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ===================================================================
/// MODEL
class _CuisineItem {
  _CuisineItem(this.id, this.label, {this.selected = false});
  final String id;
  final String label;
  bool selected;
}

/// ===================================================================
/// PROGRESS ROW
/// 6 skinny rounded bars, first [activeCount] teal, rest gray
class _StepProgressRow extends StatelessWidget {
  const _StepProgressRow({
    required this.activeCount,
    required this.totalCount,
  });

  final int activeCount;
  final int totalCount;

  static const _teal = _CuisinePreferenceScreenState._teal;
  static const _inactive = _CuisinePreferenceScreenState._stepInactive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalCount * 2 - 1, (i) {
        if (i.isOdd) {
          return const SizedBox(width: 8);
        }
        final stepIndex = i ~/ 2; // 0-based
        final color = stepIndex < activeCount ? _teal : _inactive;
        return Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      }),
    );
  }
}

/// ===================================================================
/// ONE CUISINE CARD
///
/// White card (#FEFEFE), radius 8,
/// padding horiz 24 / vert 20,
/// Row:
/// [checkbox 24x24] 12px gap [label 16 / 400 / #212121]
class _CuisineCard extends StatelessWidget {
  const _CuisineCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _cardBg = _CuisinePreferenceScreenState._cardBg;
  static const _textPrimary = _CuisinePreferenceScreenState._textPrimary;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _CuisineCheckbox(checked: selected),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    fontFamily: 'Roboto',
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
/// - size: 24x24
/// - radius: 3-4px
/// - unchecked: stroke teal 2px, white fill
/// - checked: teal fill, white check icon
class _CuisineCheckbox extends StatelessWidget {
  const _CuisineCheckbox({required this.checked});
  final bool checked;

  static const _teal = _CuisinePreferenceScreenState._teal;
  static const _bg = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: checked ? _teal : _bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _teal,
          width: 2,
        ),
      ),
      child: checked
          ? const Center(
        child: Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        ),
      )
          : null,
    );
  }
}

/// ===================================================================
/// ADDITIONAL INFO FIELD
///
/// pill radius 128,
/// 1px #E9E9E9 stroke,
/// padding 16,
/// leading icon (basket), placeholder #6A6A6A
class _AdditionalInfoField extends StatelessWidget {
  const _AdditionalInfoField({
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  static const _dividerGrey = _CuisinePreferenceScreenState._dividerGrey;
  static const _textSecondary = _CuisinePreferenceScreenState._textSecondary;
  static const _teal = _CuisinePreferenceScreenState._teal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _CuisinePreferenceScreenState._cardBg,
        borderRadius: BorderRadius.circular(128),
        border: Border.all(color: _dividerGrey, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // basket / grocery cart icon-ish (placeholder)
          Icon(
            Icons.shopping_basket_outlined,
            size: 20,
            color: _teal,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: _CuisinePreferenceScreenState._textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.3,
                fontFamily: 'Roboto',
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================================================================
/// NEXT ARROW BUTTON
///
/// full width pill, height 56,
/// radius ~100 (Figma shows very round),
/// bg teal, centered white arrow "->"
class _NextArrowButton extends StatelessWidget {
  const _NextArrowButton({required this.onTap});

  final VoidCallback onTap;

  static const _teal = _CuisinePreferenceScreenState._teal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: _teal,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: const Center(
            child: _ArrowIconWhite(),
          ),
        ),
      ),
    );
  }
}

/// Tiny arrow that matches Figma (a short line with a > at the end).
/// Here we fake it with Icons.arrow_right_alt rounded.
class _ArrowIconWhite extends StatelessWidget {
  const _ArrowIconWhite();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_right_alt_rounded,
      size: 28,
      color: Colors.white,
    );
  }
}
