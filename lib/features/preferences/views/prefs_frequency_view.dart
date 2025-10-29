import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ai/features/preferences/views/prefs_budget_view.dart';

import '../widgets/next_button.dart';

class ShoppingFrequencyScreen extends StatefulWidget {
  const ShoppingFrequencyScreen({super.key});

  @override
  State<ShoppingFrequencyScreen> createState() =>
      _ShoppingFrequencyScreenState();
}

class _ShoppingFrequencyScreenState extends State<ShoppingFrequencyScreen> {
  /// ===== FIGMA TOKENS =====
  static const _pageBg = Color(0xFFF4F6F6); // root background
  static const _statusTeal = Color(0xFF002C2E); // dark strip behind status bar
  static const _cardBg = Color(0xFFFEFEFE); // white card
  static const _teal = Color(0xFF33595B); // teal radio + CTA bg
  static const _textPrimary = Color(0xFF212121); // heading + row label
  static const _textStepInactive = Color(0xFFBABABA);

  // Options shown in order
  final List<_FreqOption> _options = const [
    _FreqOption(id: 'daily', label: 'Daily'),
    _FreqOption(id: 'weekly', label: 'Weekly'),
    _FreqOption(id: 'biweekly', label: 'Bi-Weekly'),
    _FreqOption(id: 'monthly', label: 'Monthly'),
  ];

  String? _selectedId; // single-select

  void _onSelect(String id) {
    setState(() {
      _selectedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Match Figma: white status icons on dark teal top bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ));

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        top: false, // we draw our own custom status bar region
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// ===============================
            /// 1. Fake iOS status bar background (#002C2E)
            ///    The actual OS status info sits above this via SystemChrome
            /// ===============================
            Container(
              color: _statusTeal,
              height: media.padding.top, // same trick we used elsewhere
            ),

            /// ===============================
            /// 2. Six-step progress indicator row
            ///    For this screen in Figma:
            ///      steps 1-5 = teal
            ///      step 6    = gray
            /// ===============================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                children: const [
                  Expanded(child: _StepBar(active: true)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(active: true)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(active: true)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(active: true)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(active: true)),
                  SizedBox(width: 8),
                  Expanded(child: _StepBar(active: false)),
                ],
              ),
            ),

            /// ===============================
            /// 3. Scrollable content
            /// ===============================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Title ("Confirm Your Shopping Frequency")
                    const Text(
                      'Confirm Your Shopping Frequency',
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

                    /// Cards list
                    Column(
                      children: [
                        for (final opt in _options) ...[
                          _FrequencyCard(
                            label: opt.label,
                            selected: _selectedId == opt.id,
                            onTap: () => _onSelect(opt.id),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),

                    const SizedBox(height: 120), // leave air above CTA space
                  ],
                ),
              ),
            ),

            /// ===============================
            /// 4. Bottom CTA pill:
            ///    - Rounded radius 40 (visually 100 in some comps)
            ///    - 56px tall
            ///    - Full width minus 24px margin on both sides
            ///    - Only visible AFTER user selects an option
            /// ===============================
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: (_selectedId == null)
                  ? const SizedBox(height: 24)
                  : Padding(
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
                        builder: (_) => const SpendingLimitScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// Model for frequency options
class _FreqOption {
  final String id;
  final String label;
  const _FreqOption({
    required this.id,
    required this.label,
  });
}

/// One of the small progress bars at the top
class _StepBar extends StatelessWidget {
  final bool active;
  const _StepBar({required this.active});

  static const _teal = Color(0xFF33595B);
  static const _inactive = Color(0xFFBABABA);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active ? _teal : _inactive,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

/// The selectable row card from Figma:
/// - White rounded 8
/// - Horizontal padding 24, vertical padding 20
/// - Left: radio + text
/// - Radio is a 24x24 circle outline in teal; if selected, there's an
///   inner filled dot (same teal) ~8px centered.
class _FrequencyCard extends StatelessWidget {
  const _FrequencyCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _cardBg = Color(0xFFFEFEFE);
  static const _teal = Color(0xFF33595B);
  static const _textPrimary = Color(0xFF212121);

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
              _RadioDot(selected: selected),
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
        ),
      ),
    );
  }
}

/// 24x24 circular radio control matching Figma
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});
  final bool selected;

  static const _teal = Color(0xFF33595B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: _teal, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: selected ? 8 : 0,
        height: selected ? 8 : 0,
        decoration: BoxDecoration(
          color: selected ? _teal : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Bottom pill CTA with arrow only
/// - height 56
/// - radius 40 (looks like full pill)
/// - teal background
/// - centered arrow icon, white stroke
class _NextButton extends StatelessWidget {
  const _NextButton({required this.onPressed});

  final VoidCallback onPressed;

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
          onTap: onPressed,
          child: const Center(
            child: _ArrowIcon(),
          ),
        ),
      ),
    );
  }
}

/// Chevron-arrow icon that matches Figma (“→” with a little tail)
class _ArrowIcon extends StatelessWidget {
  const _ArrowIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(32, 16.64),
      painter: _ArrowPainter(),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // We'll draw a simple horizontal line + angled head.
    final paint = Paint()
      ..color = const Color(0xFFFEFEFE)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final midY = size.height / 2;

    // shaft
    final shaftStart = Offset(size.width * 0.25, midY);
    final shaftEnd = Offset(size.width * 0.65, midY);
    canvas.drawLine(shaftStart, shaftEnd, paint);

    // arrow head: ">" shape
    final headP1 = Offset(size.width * 0.55, midY - size.height * 0.2);
    final headP2 = Offset(size.width * 0.7, midY);
    final headP3 = Offset(size.width * 0.55, midY + size.height * 0.2);

    final path = Path()
      ..moveTo(headP1.dx, headP1.dy)
      ..lineTo(headP2.dx, headP2.dy)
      ..lineTo(headP3.dx, headP3.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
