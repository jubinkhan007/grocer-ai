import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ai/features/preferences/views/prefs_diet_view.dart';

import '../widgets/next_button.dart';

class HouseholdScreen extends StatefulWidget {
  const HouseholdScreen({super.key});

  @override
  State<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends State<HouseholdScreen> {
  /// ===== FIGMA TOKENS =====
  static const _pageBg = Color(0xFFF4F6F6);
  static const _statusTeal = Color(0xFF002C2E); // status bar strip
  static const _teal = Color(0xFF33595B); // teal text / borders
  static const _textPrimary = Color(0xFF212121);
  static const _inactiveStep = Color(0xFFBABABA);
  static const _cardBg = Color(0xFFFEFEFE);
  static const _iconTileBg = Color(0xFFE6EAEB);

  int _adults = 2;
  int _kids = 2;
  int _pets = 0;

  void _incAdults() => setState(() => _adults++);
  void _decAdults() => setState(() {
    if (_adults > 0) _adults--;
  });

  void _incKids() => setState(() => _kids++);
  void _decKids() => setState(() {
    if (_kids > 0) _kids--;
  });

  void _incPets() => setState(() => _pets++);
  void _decPets() => setState(() {
    if (_pets > 0) _pets--;
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // white status icons over dark teal bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ));

    final showNextButton = (_adults + _kids + _pets) >= 0; // always true for now
    // If you only want to show after at least one selection, change to > 0.

    return Scaffold(
      backgroundColor: _pageBg,
      body: Column(
        children: [
          /// ===== STATUS STRIP (dark teal behind system status items) =====
          Container(
            color: _statusTeal,
            padding: EdgeInsets.only(
              top: media.padding.top,
              bottom: 8,
              left: 24,
              right: 24,
            ),
          ),

          /// ===== PROGRESS BAR ROW (6 steps, first 2 teal, rest gray) =====
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Row(
              children: const [
                Expanded(child: _StepBar(color: _teal)),
                SizedBox(width: 8),
                Expanded(child: _StepBar(color: _teal)),
                SizedBox(width: 8),
                Expanded(child: _StepBar(color: _inactiveStep)),
                SizedBox(width: 8),
                Expanded(child: _StepBar(color: _inactiveStep)),
                SizedBox(width: 8),
                Expanded(child: _StepBar(color: _inactiveStep)),
                SizedBox(width: 8),
                Expanded(child: _StepBar(color: _inactiveStep)),
              ],
            ),
          ),

          /// ===== BODY CONTENT (scrollable) =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Title
                  const Text(
                    'Confirm your household',
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

                  /// Adults card
                  _HouseholdCard(
                    icon: Icons.group, // replace w/ Figma asset when you have it
                    label: 'Adults',
                    count: _adults,
                    onMinus: _decAdults,
                    onPlus: _incAdults,
                  ),
                  const SizedBox(height: 16),

                  /// Kids card
                  _HouseholdCard(
                    icon: Icons.escalator_warning_rounded,
                    label: 'Kids',
                    count: _kids,
                    onMinus: _decKids,
                    onPlus: _incKids,
                  ),
                  const SizedBox(height: 16),

                  /// Pets card
                  _HouseholdCard(
                    icon: Icons.pets,
                    label: 'Pets',
                    count: _pets,
                    onMinus: _decPets,
                    onPlus: _incPets,
                  ),

                  const SizedBox(height: 160), // space above bottom pill
                ],
              ),
            ),
          ),

          /// ===== BOTTOM NEXT PILL =====
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: showNextButton
                ? Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                24 + media.padding.bottom,
              ),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Material(
                  color: _teal,
                  borderRadius: BorderRadius.circular(40),
                  child: NextArrowButton(
                    onNext: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DietaryPreferenceScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// One of the little progress bars at the top
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

/// White rounded card row for Adults/Kids/Pets
///
/// Layout:
/// [ 36x36 icon tile ][ label ]               [ (-)  count  (+) ]
///
/// - Card bg: #FEFEFE
/// - Card radius: 8
/// - Card padding: horizontal 24, vertical 20
/// - Icon tile: 36x36, radius 4, bg #E6EAEB, teal icon
/// - Minus / Plus buttons: 32x32 circle, 1px teal stroke, transparent bg,
///   icon is teal, minus/plus glyph ~16px
class _HouseholdCard extends StatelessWidget {
  const _HouseholdCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.onMinus,
    required this.onPlus,
  });

  static const _cardBg = Color(0xFFFEFEFE);
  static const _iconTileBg = Color(0xFFE6EAEB);
  static const _teal = Color(0xFF33595B);
  static const _textPrimary = Color(0xFF212121);

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// left group: icon tile + label
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _iconTileBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: _teal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ],
          ),

          /// right group:  (-)  count  (+)
          Row(
            children: [
              _CircleIconBtn(
                icon: Icons.remove,
                onTap: onMinus,
                enabled: count > 0,
              ),
              const SizedBox(width: 16),
              Text(
                '$count',
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
              const SizedBox(width: 16),
              _CircleIconBtn(
                icon: Icons.add,
                onTap: onPlus,
                enabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Circular +/- button
/// - 32x32 circle
/// - stroke 1px #33595B
/// - transparent fill
/// - icon teal, size 20
class _CircleIconBtn extends StatelessWidget {
  const _CircleIconBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  static const _teal = Color(0xFF33595B);
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final borderColor = _teal.withOpacity(enabled ? 1 : 0.4);
    final iconColor = _teal.withOpacity(enabled ? 1 : 0.4);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: borderColor, width: 1),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}

/// Teal pill button content arrow
/// Figma shows a thin arrow ➝, not text
class _ArrowIconWhite extends StatelessWidget {
  const _ArrowIconWhite();

  @override
  Widget build(BuildContext context) {
    // We'll approximate with a long arrow: "→"
    // If you have the exact SVG, replace this block.
    return Text(
      '→',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1,
      ),
    );
  }
}
