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

  @override
  Widget build(BuildContext context) {
    // The plugin shows a dark status area with light icons.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: _statusBarBg,
        statusBarBrightness: Brightness.dark, // iOS
        statusBarIconBrightness: Brightness.light, // Android
      ),
    );

    return Scaffold(
      backgroundColor: _screenBg,
      body: PageView.builder(
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
            onSkip: controller.skip,
            onNext: controller.next,
          );
        },
      ),
    );
  }
}

/// This builds ONE slide exactly like the plugin layout
class _OnboardingSlideScreen extends StatelessWidget {
  const _OnboardingSlideScreen({
    required this.page,
    required this.pageIndex,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
  });

  final OnbPage page;
  final int pageIndex;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Figma frame is 430 x 932. We'll scale positions so it's proportional
    // on other screens, but preserve pixel intent.
    const figmaW = 430.0;
    const figmaH = 932.0;
    final scaleW = size.width / figmaW;
    final scaleH = size.height / figmaH;

    // Token styles from plugin dump
    const titleStyle = TextStyle(
      color: _titleColor,
      fontSize: 24,
      fontWeight: FontWeight.w600, // Figma said 600
      height: 1.2, // tighter like plugin, not too tall
      fontFamily: 'Roboto',
    );

    const bodyStyle = TextStyle(
      color: _bodyColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.70, // plugin showed 1.70
      fontFamily: 'Roboto',
    );

    return Container(
      width: size.width,
      height: size.height,
      color: _screenBg,
      //clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          /// ===== big soft oval background behind hero art =====
          Positioned(
            left: -135 * scaleW,
            top: -80 * scaleH,
            child: Container(
              width: 700 * scaleW,
              height: 700 * scaleW, // keep it round-ish
              decoration: const ShapeDecoration(
                color: _bgOval,
                shape: OvalBorder(),
              ),
            ),
          ),

          /// ===== dark status bar strip (48px tall in plugin) =====
          Positioned(
            left: 0,
            top: 0,
            width: size.width,
            height: 48 * scaleH,
            child: Container(
              color: _statusBarBg,
              // We won't try to pixel-copy carrier/wifi/battery, we just
              // render the bar. If you want fake status text: uncomment.
              // child: Padding(
              //   padding: EdgeInsets.only(
              //     left: 24.5 * scaleW,
              //     top: 15.32 * scaleH,
              //   ),
              //   child: Text(
              //     '9:41',
              //     style: TextStyle(
              //       color: const Color(0xFFE9E9E9),
              //       fontSize: 16.41 * scaleW,
              //       fontWeight: FontWeight.w600,
              //       letterSpacing: -0.18 * scaleW,
              //       fontFamily: 'SF Pro Text',
              //     ),
              //   ),
              // ),
            ),
          ),

          /// ===== "SKIP >" row in dark text, below status bar =====
          Positioned(
            left: 356 * scaleW,
            top: 72 * scaleH,
            child: InkWell(
              onTap: onSkip,
              borderRadius: BorderRadius.circular(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SKIP',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(width: 4 * scaleW),
                  // simple chevron_right
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFF212121),
                  ),
                ],
              ),
            ),
          ),

          /// ===== HERO ILLUSTRATION BLOCK =====
          /// In the plugin we saw:
          /// Positioned left:56, top:116, width:319, height:400
          /// It's basically the artwork area.
          Positioned(
            left: 56 * scaleW,
            top: 116 * scaleH,
            width: 319 * scaleW,
            height: 400 * scaleH,
            child: Center(
              child: Image.asset(
                page.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// ===== TEXT + PROGRESS + NEXT cluster near bottom =====
          /// Plugin puts this whole column starting at top:696 left:24 width:382
          Positioned(
            left: 24 * scaleW,
            // If the device is taller than 932, push it down proportionally.
            // This matches Figma baseline but still sits ~above home bar.
            top: 696 * scaleH,
            width: 382 * scaleW,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title + subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: titleStyle,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 64),

                // Bottom row: progress indicator + "Next" button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PluginProgressDots(
                      total: totalPages,
                      current: pageIndex,
                    ),
                    _PluginNextButton(onTap: onNext),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    required this.current,
  });

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int i = 0; i < total; i++) {
      if (i == current) {
        // active segment = 24px line (2px tall) + 8x8 solid dot
        children.add(
          SizedBox(
            width: 32, // 24 line + 8 dot overlaps visually
            height: 8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 3,
                  child: Container(
                    width: 24,
                    height: 2,
                    decoration: BoxDecoration(
                      color: _dotActiveColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _dotActiveColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // faded circle 8x8 @ 40% alpha of same teal tone
        children.add(
          Opacity(
            opacity: 0.40,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _dotInactiveColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// "Next" button from plugin:
/// width: 102, height: 44, radius: 8, bg #33595B
/// Text: "Next" 16/600 white, + chevrons
class _PluginNextButton extends StatelessWidget {
  const _PluginNextButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 102, // Figma button width
        minHeight: 44, // Figma button height
      ),
      child: Material(
        color: const Color(0xFF33595B),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                // this replaces the two Icons.chevron_right_rounded
                Image.asset(
                  'assets/icons/chevron_double_right.png', // <-- your asset path
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                  color: const Color(0xFFFEFEFE), // forces it to render white
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}