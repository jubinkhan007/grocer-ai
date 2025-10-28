import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'invite_friends_sheet.dart';

/// ===== COLOR TOKENS (from Figma / screenshots) =====
const _bgPage = Color(0xFFF4F6F6);       // page background & sheet background
const _statusTeal = Color(0xFF002C2E);   // dark teal status bar + "Continue" CTA
const _tealButton = Color(0xFF33595B);   // teal for sheet CTAs ("Send", "Share")
const _textPrimary = Color(0xFF212121);  // black-ish text
const _dividerGrey = Color(0xFFB0BFBF);  // grey lines around "Or"
const _cardBg = Color(0xFFFEFEFE);       // white card bg
const _shadowColor = Color(0x1915224F);  // rgba-ish shadow from Figma (10% ish)

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Force light icons in the dark teal strip like Figma's screenshot header.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark,      // iOS
    ));

    return Scaffold(
      backgroundColor: _bgPage,
      body: Stack(
        children: [
          /// ================== PAGE CONTENT ==================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- Fake status bar strip (the dark teal bar behind 9:41 / wifi / battery) -----
              Container(
                width: double.infinity,
                color: _statusTeal,
                padding: EdgeInsets.only(
                  top: media.padding.top,
                  left: 24,
                  right: 24,
                  bottom: 12, // total visual height ~48
                ),
                // We do NOT draw "9:41" etc. The screenshot shows it,
                // but in the real app the OS paints that.
              ),

              const SizedBox(height: 16),

              // ----- White rounded congratulation card -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // badge illustration 100x100
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/award_badge.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // "Congratulations!!"
                      const Text(
                        'Congratulations!!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3-line body text with inline bold spans
                      Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(text: 'You saved '),
                                TextSpan(
                                  text: '\$6.23',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' with GrocerAI today!'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(text: 'Your Walmart order totals '),
                                TextSpan(
                                  text: '\$243',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your order will arrive by 6 PM on January 6, 2025',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // "Continue" CTA (dark teal, full width, 56h, radius 100)
                      _FullWidthPillButton(
                        label: 'Continue',
                        bgColor: _statusTeal, // matches screenshot (same dark teal as status bar)
                        textStyle: const TextStyle(
                          color: Color(0xFFFEFEFE),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        onTap: () {
                          // hook up whatever "Continue" does
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 64px gap between bottom of card and "Or" divider in the screenshot
              const SizedBox(height: 64),

              // ----- "Or" divider row -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(child: Container(height: 1, color: _dividerGrey)),
                    const SizedBox(width: 16),
                    const Text(
                      'Or',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Container(height: 1, color: _dividerGrey)),
                  ],
                ),
              ),

// gap between "Or" and the sheet radius lip
              const SizedBox(height: 16),

// 👇 instead of Spacer(), just give fixed space equal to sheet height
              const SizedBox(height: 360),

              // this spacer is the grey overlap area behind the sheet lip
              const SizedBox(height: 16),

              // give the stack something to "sit on" behind the sheet
              const Spacer(),
            ],
          ),

          /// ================== DIMMED SCRIM ==================
          ///
          /// Screenshot shows the dark overlay starting immediately
          /// BELOW the teal status strip (not covering it).
          Positioned.fill(
            top: media.padding.top+12, // ~status strip total height
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                color: Colors.black.withOpacity(0.40),
              ),
            ),
          ),

          /// ================== BOTTOM SHEET ==================
          ///
          /// Pixel-spec rounded top 40, grabber, etc.
          Align(
            alignment: Alignment.bottomCenter,
            child: InviteFriendsSheet(
              onSkip: () {
                // e.g. Navigator.of(context).pop();
              },
              onCopyTap: () {
                // Clipboard.setData(...)
              },
              onShareTap: () {
                // native share intent
              },
              onSendTap: () {
                // send invite
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// shared 56px-tall pill button with Stadium-ish radius 100
class _FullWidthPillButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final TextStyle textStyle;
  final VoidCallback onTap;

  const _FullWidthPillButton({
    required this.label,
    required this.bgColor,
    required this.textStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: _shadowColor,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(label, style: textStyle),
          ),
        ),
      ),
    );
  }
}
