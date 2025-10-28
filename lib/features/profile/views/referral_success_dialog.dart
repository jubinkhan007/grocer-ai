import 'package:flutter/material.dart';

const _tealHeader = Color(0xFF33595B); // pill button bg
const _textPrimary = Color(0xFF212121);
const _textSecondary = Color(0xFF4D4D4D);
const _surfaceWhite = Color(0xFFFFFFFF);

class ReferralCongratsDialog extends StatelessWidget {
  final String amountEarned;
  final VoidCallback? onInviteAnother;
  final VoidCallback? onClose;

  const ReferralCongratsDialog({
    super.key,
    required this.amountEarned,
    this.onInviteAnother,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // LayoutBuilder lets us see how much vertical space we actually have
      builder: (context, constraints) {
        // we'll keep at least 32px of breathing room above+below the card
        final maxCardHeight = constraints.maxHeight - 64;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Figma width = 382 on 430 canvas
              maxWidth: 382,
              // don't let the card grow taller than screen minus padding
              maxHeight: maxCardHeight,
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _surfaceWhite,
                  borderRadius: BorderRadius.circular(24),
                ),

                // if content is taller than maxHeight, this scrolls
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch, // <- full width
                    children: [
                      // ---- close button row (top right) ----
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onClose ?? () => Navigator.of(context).pop(),
                            child: const Center(
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: _textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ---- illustration ----
                      // 236 x 236 from Figma
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 236,
                          height: 236,
                          child: Image.asset(
                            'assets/images/referral_congrats_coins.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---- headline / subheadline ----
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Congratulations!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You have just earned \$$amountEarned',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _textPrimary,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ---- body copy ----
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 334),
                        child: const Text(
                          'One of your friends has joined by your referral code. '
                              'Do more invitations to earn more.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textSecondary,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ---- CTA button ----
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: onInviteAnother,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tealHeader,
                            elevation: 0,
                            shape: const StadiumBorder(), // radius 100 look
                          ),
                          child: const Text(
                            'Invite another',
                            style: TextStyle(color: _surfaceWhite, fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
