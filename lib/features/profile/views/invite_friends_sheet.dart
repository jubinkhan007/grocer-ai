import 'package:flutter/material.dart';

/// ===== SAME TOKENS (keep them in sync with screen file) =====
const _sheetBg = Color(0xFFF4F6F6);        // bottom sheet bg (same as page bg)
const _tealButton = Color(0xFF33595B);     // teal used in "Send" and mini "Share"
const _textPrimary = Color(0xFF212121);
const _textSecondary = Color(0xFF6A6A6A);  // light grey labels under icons / code
const _shadowColor = Color(0x1915224F);    // subtle drop for buttons
const _dividerLight = Color(0xFFE0E0E0);   // 1px divider under header
const _pillHalo = Color(0xFFE9E9E9);       // grabber pill color

class InviteFriendsSheet extends StatelessWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onCopyTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onSendTap;

  const InviteFriendsSheet({
    super.key,
    this.onSkip,
    this.onCopyTap,
    this.onShareTap,
    this.onSendTap,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _sheetBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 24,
        right: 24,
        bottom: 24 + media.padding.bottom, // keep above home indicator
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---- Grabber w/ soft halo ----
          ///
          /// Screenshot shows a light rounded bar with a faint glow under it.
          Center(
            child: Container(
              // wrap in a Stack so we can add a subtle blurred halo
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: _pillHalo,
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000), // ~20% black glow
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// ---- Header row: "Invite friends" .... "Skip" ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Invite friends',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSkip,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: _tealButton,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // thin divider (#E0E0E0)
          Container(
            width: double.infinity,
            height: 1,
            color: _dividerLight,
          ),

          const SizedBox(height: 24),

          /// ---- "Share this link via" ----
          const Text(
            'Share this link via',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 20),

          /// ---- social row: each item is 48x48 icon + 12px gap + 14 label ----
          ///
          /// Gaps between items are exactly 24 in your dump.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // In the screenshot it fits 5 icons across on a 430 canvas,
            // but we'll keep horizontal scroll safe for narrower phones.
            child: Row(
              children: const [
                _ShareTarget(
                  label: 'Email',
                  assetPath: 'assets/icons/email.png',
                ),
                SizedBox(width: 24),
                _ShareTarget(
                  label: 'Facebook',
                  assetPath: 'assets/icons/facebook.png',
                ),
                SizedBox(width: 24),
                _ShareTarget(
                  label: 'Twitter',
                  assetPath: 'assets/icons/twitter.png',
                ),
                SizedBox(width: 24),
                _ShareTarget(
                  label: 'LinkedIn',
                  assetPath: 'assets/icons/linkedin.png',
                ),
                SizedBox(width: 24),
                _ShareTarget(
                  label: 'Whatsapp',
                  assetPath: 'assets/icons/whatsapp.png',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ---- "Share link" label ----
          const Text(
            'Share link',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 20),

          /// ---- Row: [ big pill with code + Copy ]   [ Share pill ] ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // left capsule (radius 128) ~56px tall
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16, // gives ~56 total height
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(128),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'michale10',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onCopyTap,
                        child: const Text(
                          'Copy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // right mini pill "Share" (teal 0xFF33595B)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onShareTap,
                child: Container(
                  height: 56, // match visual height of left capsule
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _tealButton,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Share',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// ---- Full-width "Send" CTA (tealButton, 56h, radius 100)
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: onSendTap,
              child: Ink(
                decoration: BoxDecoration(
                  color: _tealButton,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: _shadowColor,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Send',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One share target (icon circle + label)
class _ShareTarget extends StatelessWidget {
  final String assetPath;
  final String label;

  const _ShareTarget({
    required this.assetPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 63, // matches widest column ("Whatsapp")
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
