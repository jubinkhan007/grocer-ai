import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shell/main_shell_controller.dart';

/// ===== FIGMA TOKENS =====
const _bgPage = Color(0xFFF4F6F6); // page bg
const _tealStatus = Color(0xFF002C2E); // very top strip
const _tealHeader = Color(0xFF33595B); // header teal

const _cardBg = Color(0xFFFEFEFE); // surfaces
const _borderGrey = Color(0xFFE6EAEB); // 1px borders/dividers
const _borderDotted = Color(0xFF8AA0A1); // dashed box outline color

const _textPrimary = Color(0xFF212121); // heavy text
const _textSecondary = Color(0xFF4D4D4D); // paragraph grey
const _textLabelGrey = Color(0xFF6A6A6A); // "Referral code"
const _textOnTealHeaderSmall = Color(0xFFE9E9E9); // "Refer your friends"
const _textOnTealHeaderBig = Color(0xFFFEFEFE); // "Earn $189 each"

const _chipBg = Color(0xFFE6EAEB);
const _chipText = Color(0xFF33595B);

const _copyBtnBg = Color(0xFF33595B);
const _copyBtnText = Color(0xFFFEFEFE);

const _shareBg = Color(0xFFE6EAEB); // circle behind the share arrow

const _stepsBg = Color(0xFFE6EAEB); // pale grey callout bg
final shell = Get.find<MainShellController>();
class ReferralSummaryScreen extends StatelessWidget {
  const ReferralSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Light icons on dark status bar strip like Figma
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _tealStatus,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ));

    final media = MediaQuery.of(context);

    return Scaffold(
      // DO NOT add bottomNavigationBar here.
      // MainShell shows FFBottomNav underneath this route.
      backgroundColor: _bgPage,
      body: Column(
        children: [
          /// ===== TOP STATUS STRIP (matches dark 48px-ish bar in Figma) =====
          Container(
            width: double.infinity,
            color: _tealStatus,
            padding: EdgeInsets.only(
              top: media.padding.top, // notch / status inset
              left: 24,
              right: 24,
              bottom: 12, // Figma shows ~48 total height w/ time row spacing
            ),
            // We won't try to fake the exact "9:41   signal battery" row.
            // Leaving this empty keeps the tealStatus height visually correct.
          ),

          /// ===== REST OF SCREEN SCROLLS =====
          Expanded(
            child: SingleChildScrollView(
              // keep room so the last FAQ row isn't hidden by shell nav bar
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== HEADER TEAL BLOCK WITH OVERLAY CARD =====
                  SizedBox(
                    height: 280, // exact teal header height from Figma
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // teal background fill
                        Positioned.fill(
                          child: Container(color: _tealHeader),
                        ),

                        // header text / back arrow / chip (24px horizontal padding)
                        Positioned(
                          left: 24,
                          right: 24,
                          top: 12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// LEFT COLUMN
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // back arrow (14x20 in Figma, but we’ll use 24x24 tap target)
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Navigator.of(context).maybePop();
                                    },
                                    child: const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          size: 20,
                                          color: _textOnTealHeaderBig,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // "Refer your friends"
                                  const Text(
                                    'Refer your friends',
                                    style: TextStyle(
                                      color: _textOnTealHeaderSmall,
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // "Earn $189 each"
                                  const Text(
                                    'Earn \$189 each',
                                    style: TextStyle(
                                      color: _textOnTealHeaderBig,
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // "My referral" pill
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      shell.openMyReferralList();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20, // 16 + 4 == 20 from Figma
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _chipBg,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'My referral',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _chipText,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const Spacer(),

                              /// RIGHT COIN ART
                              SizedBox(
                                width: 114.25,
                                height: 122.87,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // glowing yellow circle ~78x78 behind coins
                                    Positioned(
                                      top: 8,
                                      child: Container(
                                        width: 78,
                                        height: 78,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFFCD252),
                                        ),
                                      ),
                                    ),
                                    // TODO: replace with exported coin stack asset from Figma
                                    Image.asset(
                                      "assets/images/referral_coins.png",
                                      // color: Color(0xFFFFEB3B),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// CREDIT SUMMARY CARD that visually sits ~halfway down teal
                        Positioned(
                          left: 24,
                          right: 24,
                          top: 146, // tuned to match the screenshot overlap
                          child: const _CreditSummaryCard(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ===== STEPS CALLOUT BOX =====
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
                    child: const _InviteStepsBox(),
                  ),

                  const SizedBox(height: 24),

                  /// ===== FAQ SECTION =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const _FaqSection(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= CREDIT SUMMARY CARD =================
/// White rounded-8 card with 1px #E6EAEB border.
/// Top row:
///   [ coin icon ] Total credit / $189            [ share circle ]
/// Subdivider 1px #E6EAEB
/// "Referral code" / code + "Copy" pill on right.
///
/// Also includes the faint watermark circle art in the top-right of the card
/// per Figma (we'll fake that with an Opacity stack).
class _CreditSummaryCard extends StatelessWidget {
  const _CreditSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      // Stack so we can layer watermark behind content
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderGrey, width: 1),
      ),
      child: Stack(
        children: [
          // watermark coin / rupee outline in top-right w/ very low opacity
          Positioned(
            top: 16,
            right: 16,
            child: Opacity(
              opacity: 0.04,
              // TODO: replace with the faint rupee watermark vector from Figma
              child: Transform.rotate(
                angle: -0.70,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // actual card content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TOP ROW: coin avatar + text + share chip
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 48x48 yellow coin circle
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFC107), // you'll swap for the real asset background
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // TEXT BLOCK: let it size naturally
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Total credit',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 20, // this needs to go up to match Figma (see below)
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$189',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 28, // ↑ more on this below
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // share chip on the right
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _cardBg.withOpacity(0.9), // we'll update this in #2
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _borderGrey,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.ios_share,
                        size: 24,
                        color: _tealHeader,
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 12),

                // divider line 1px #E6EAEB
                Container(
                  width: double.infinity,
                  height: 1,
                  color: _borderGrey,
                ),

                const SizedBox(height: 12),

                /// REFERRAL CODE ROW
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column: "Referral code" + code
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Referral code',
                            style: TextStyle(
                              color: _textLabelGrey,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'michale10',
                            style: TextStyle(
                              color: _tealHeader,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // "Copy" pill (40 height, 100 radius)
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _copyBtnBg,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Copy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _copyBtnText,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
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

/// ================= INVITE STEPS BOX =================
/// Rounded-10 box, bg #E6EAEB, 1px #8AA0A1,
/// 3 rows of icon + text like in the mock.
class _InviteStepsBox extends StatelessWidget {
  const _InviteStepsBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _stepsBg, // E6EAEB
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _borderDotted, // 8AA0A1
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          _StepRow(
            // TODO: swap this Icon() for the multicolor "link" asset from Figma
            icon: Icons.link,
            text:
            'Invite your Friend to install the app with the\nlink',
          ),
          SizedBox(height: 16),
          _StepRow(
            // TODO: swap this Icon() for the yellow box asset from Figma
            icon: Icons.inventory_2_outlined,
            text: 'Your friend places a minimum order of ₹300',
          ),
          SizedBox(height: 16),
          _StepRow(
            // TODO: swap this Icon() for the bag/coins asset from Figma
            icon: Icons.card_giftcard_outlined,
            text:
            'You get ₹150 once the return period is over',
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _StepRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 44x44 white circle with subtle shadow
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24,
            color: _tealHeader,
          ),
        ),
        const SizedBox(width: 16), // Figma spacing is ~16 between icon+text
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 16, // screenshot text visually reads closer to 16
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

/// ================= FAQ SECTION =================
/// Title, subtitle, and list of FAQ rows.
/// First row is expanded with answer text and a "minus" bubble on the right.
/// Remaining rows are collapsed with a "plus" bubble.
class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently asked questions',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Everything you need to know about the order and credit',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 24),

        /// Expanded item
        const _FaqExpandedItem(
          question: 'Is there a free trial available?',
          answer:
          'Yes, you can try us for free for 30 days. If you want, we’ll provide you with a free, personalized 30-minute onboarding call to get you up and running as soon as possible.',
        ),
        const _FaqDivider(),

        /// Collapsed rows
        const _FaqCollapsedItem(
          question: 'Can I change my plan later?',
        ),
        const _FaqDivider(),

        const _FaqCollapsedItem(
          question: 'What is your cancellation policy?',
        ),
        const _FaqDivider(),

        const _FaqCollapsedItem(
          question: 'Can other info be added to an invoice?',
        ),
        const _FaqDivider(),

        const _FaqCollapsedItem(
          question: 'How does billing work?',
        ),
        const _FaqDivider(),

        const _FaqCollapsedItem(
          question: 'How do I change my account email?',
        ),
      ],
    );
  }
}

class _FaqDivider extends StatelessWidget {
  const _FaqDivider();

  @override
  Widget build(BuildContext context) {
    // This mimics the 16px vertical gap plus a 1px #E6EAEB line
    return Container(
      padding: EdgeInsetsGeometry.only(top: 15),
      height: 16,
      alignment: Alignment.topCenter,
      child: Container(
        height: 1,
        color: _borderGrey,
      ),
    );
  }
}

class _FaqExpandedItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqExpandedItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // text block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 18, // screenshot headline looks ~18 bold
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                answer,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // minus bubble
        const _FaqIcon(expanded: true),
      ],
    );
  }
}

class _FaqCollapsedItem extends StatelessWidget {
  final String question;
  const _FaqCollapsedItem({required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Figmas rows breathe a lot vertically before the divider line.
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // question text
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const _FaqIcon(expanded: false),
        ],
      ),
    );
  }
}

/// Little circular outline badge on the right side of FAQ rows,
/// teal border 2px, teal "+" or "−" inside.
///
/// Figma shows something closer to 24x24 than Material's 20x20 outline icons.
class _FaqIcon extends StatelessWidget {
  final bool expanded; // true => minus, false => plus
  const _FaqIcon({required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _tealHeader,
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          expanded ? Icons.remove : Icons.add,
          size: 16,           // matches the Figma stroke weight visually
          color: _tealHeader, // same teal as the border
        ),
      ),
    );
  }
}

