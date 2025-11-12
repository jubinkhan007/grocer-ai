import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';

/// ===== Figma tokens pulled from plugin =====
const _screenBg = Color(0xFFF4F6F6); // page background
const _bgOval = Color(0xFFE6EAEB);   // giant blurry oval behind art
const _statusBarBg = Color(0xFF002C2E); // top 48px bar in plugin dump

const _titleColor = Color(0xFF212121); // heading
const _bodyColor = Color(0xFF4D4D4D);  // body text

const _dotActiveColor = Color(0xFF33595B); // active line + dot color
const _dotInactiveColor = Color(0xFF33595B); // same hue but faded 40%

const _nextBtnBg = Color(0xFF33595B);

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  double _topBarHeight(BuildContext context) {
    const figma = 48.0;                       // desired visible strip
    final pad = MediaQuery.of(context).padding.top;
    // ensure we never paint less than the system inset
    return pad > figma ? pad : figma;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusBarBg,           // teal
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: _screenBg,
      body: Stack(
        children: [
          // your existing PageView
          PageView.builder(
            controller: controller.pageController,
            physics: const ClampingScrollPhysics(),
            onPageChanged: controller.onChanged,
            itemCount: controller.pages.length,
            itemBuilder: (context, index) {
              final page = controller.pages[index];
              final total = controller.pages.length;
              return _OnboardingSlideScreen(
                page: page,
                pageIndex: index,
                totalPages: total,
                pageController: controller.pageController,
                onSkip: controller.skip,
                onNext: controller.next,
              );
            },
          ),

          // SINGLE teal status bar fill (exactly like Figma)
          Positioned(
            top: 0, left: 0, right: 0,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: _statusBarBg,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              child: Container(
                height: _topBarHeight(context),   // <-- 48px or larger for notches
                color: _statusBarBg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// This builds ONE slide exactly like the plugin layout
/// This builds ONE slide exactly like the plugin layout,
/// but makes it fully responsive by drawing the 430×932 artboard
/// inside a FittedBox(BoxFit.contain).
class _OnboardingSlideScreen extends StatelessWidget {
  const _OnboardingSlideScreen({
    required this.page,
    required this.pageIndex,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
    required this.pageController,
  });

  final OnbPage page;
  final int pageIndex;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final PageController pageController;

  double _topBarHeight(BuildContext context) {
    const figma = 48.0;                       // desired visible strip
    final pad = MediaQuery.of(context).padding.top;
    // ensure we never paint less than the system inset
    return pad > figma ? pad : figma;
  }

  @override
  Widget build(BuildContext context) {
    // Fixed Figma artboard
    const figmaW = 430.0;
    const figmaH = 932.0;

    // Token styles from plugin dump
    const titleStyle = TextStyle(
      color: _titleColor,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.2,
      fontFamily: 'Roboto',
    );

    const bodyStyle = TextStyle(
      color: _bodyColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.70,
      fontFamily: 'Roboto',
    );

    return ColoredBox(
      color: _screenBg, // keeps page background around the letterboxed art
      child: Center(
        // Scales the whole 430×932 stage to always fit (no cropping)
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: figmaW,
            height: figmaH,
            child: Stack(
              children: [
                /// ===== big soft oval background behind hero art =====
                const Positioned(
                  left: -135,
                  top: -80,
                  child: SizedBox(
                    width: 700,
                    height: 700,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: _bgOval,
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                ),

                /// ===== dark status bar strip (48px tall in plugin) =====
                // const Positioned(
                //   left: 0,
                //   top: 0,
                //   width: figmaW,
                //   height: 48,
                //   child: ColoredBox(color: _statusBarBg),
                // ),

                /// ===== "SKIP >" =====
                Positioned(
                  left: 356,
                  top: (_topBarHeight(context) - 48) + 56, // = 56px below the 48px strip; stays tight on all devices
                  child: InkWell(
                    onTap: onSkip,
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'SKIP',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right_rounded,
                            size: 18, color: Color(0xFF212121)),
                      ],
                    ),
                  ),
                ),

                /// ===== HERO ILLUSTRATION BLOCK =====
                Positioned(
                  left: 56,
                  top: 116,
                  width: 319,
                  height: 400,
                  child: Center(
                    child: Image.asset(
                      page.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                /// ===== TEXT + PROGRESS + NEXT cluster =====
                Positioned(
                  left: 24,
                  top: 696,
                  width: 382,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title + subtitle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: double.infinity),
                          Text(page.title,
                              textAlign: TextAlign.center, style: titleStyle),
                          const SizedBox(height: 16),
                          Text(page.subtitle,
                              textAlign: TextAlign.center, style: bodyStyle),
                        ],
                      ),

                      const SizedBox(height: 64),

                      // Bottom row: progress indicator + "Next" button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _PluginProgressDots(
                            total: totalPages,
                            pageController: pageController, // <-- pass controller, not `current`
                          ),
                          _PluginNextButton(onTap: onNext),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Progress the way the plugin renders it:
///  - First "segment" shows a 24px line with rounded ends (2px tall),
///    + a solid 8x8 dot at the end of that line
///  - The rest dots are 8x8 circles at 40% opacity
///
/// Example from plugin for page 0 of 5:
/// [ line+dot ][ faded dot ][ faded dot ][ faded dot ][ faded dot ]
///
/// We'll recreate this generically based on `current`.
class _PluginProgressDots extends StatelessWidget {
  const _PluginProgressDots({
    required this.total,
    required this.pageController,
  });

  final int total;
  final PageController pageController;

  // Figma tokens for the indicator
  static const double _dot  = 8.0;
  static const double _gap  = 8.0;
  static const double _lead = 16.0;  // small left breathing room like the prototype
  static const double _trackH = 16.0;

  @override
  Widget build(BuildContext context) {
    final trackW = _lead + total * _dot + (total - 1) * _gap;

    return SizedBox(
      width: trackW,
      height: _trackH,
      child: AnimatedBuilder(
        animation: pageController,
        builder: (context, _) {
          double page = 0;
          if (pageController.hasClients) {
            page = pageController.page ?? pageController.initialPage.toDouble();
          }
          page = page.clamp(0.0, (total - 1).toDouble());

          // Distance between dot centers
          const base = _dot + _gap;
          final i = page.floor();
          final t = page - i; // 0..1 between i and i+1

          // Lerp the *center* between the two base dots (keeps perfect alignment)
          final fromCenter = _lead + i * base + _dot / 2;
          final toCenter   = _lead + (i + 1) * base + _dot / 2;
          final centerX    = lerpDouble(fromCenter, toCenter, t)!;

          return CustomPaint(
            size: Size(trackW, _trackH),
            painter: _DotsPainter(
              total: total,
              centerX: centerX,
            ),
          );
        },
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  _DotsPainter({
    required this.total,
    required this.centerX,
  });

  final int total;
  final double centerX;

  static const double _dot  = 8.0;
  static const double _gap  = 8.0;
  static const double _lead = 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = _dotInactiveColor.withOpacity(0.40)
      ..style = PaintingStyle.fill;
    final activePaint = Paint()
      ..color = _dotActiveColor
      ..style = PaintingStyle.fill;

    final cy = size.height / 2; // 8px track center

    // Draw base faded dots
    double cx = _lead + _dot / 2;
    for (int i = 0; i < total; i++) {
      canvas.drawCircle(Offset(cx, cy), _dot / 2, basePaint);
      cx += _dot + _gap;
    }

    // Active segment = short rounded line + solid dot at its end
    // Segment's left so that the active DOT CENTER is at +20 from left.
    final segLeft = centerX - 20.0;

    // 24px rounded line (2px tall). Right before the dot.
    final lineRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(segLeft, cy - 1, 24, 2),
      const Radius.circular(20),
    );
    canvas.drawRRect(lineRect, activePaint);

    // Solid 8×8 dot (center aligned to the moving centerX)
    canvas.drawCircle(Offset(centerX, cy), _dot / 2, activePaint);
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) =>
      oldDelegate.centerX != centerX || oldDelegate.total != total;
}

// ──────────────────────────────────────────────────────────────
// "Next" button: 102×44, radius 8, white text + double chevron
// ──────────────────────────────────────────────────────────────
class _PluginNextButton extends StatefulWidget {
  const _PluginNextButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_PluginNextButton> createState() => _PluginNextButtonState();
}

class _PluginNextButtonState extends State<_PluginNextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      height: 44,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 80),
        scale: _pressed ? 0.98 : 1.0,
        child: Material(
          color: _nextBtnBg,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: () {
              setState(() => _pressed = false);
              widget.onTap();
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Next',
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Use your asset; falls back to icon if missing.
                  Image.asset(
                    'assets/icons/chevron_double_right.png',
                    width: 16,
                    height: 16,
                    color: const Color(0xFFFEFEFE),
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.double_arrow_rounded,
                      size: 16,
                      color: Color(0xFFFEFEFE),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}