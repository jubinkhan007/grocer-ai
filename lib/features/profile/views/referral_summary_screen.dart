// lib/features/profile/views/referral_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// --- 1. IMPORT NEW MODELS AND CONTROLLER ---
import 'package:grocer_ai/features/profile/controllers/referral_summary_controller.dart';
import 'package:grocer_ai/features/profile/models/faq_model.dart';
import 'package:grocer_ai/features/profile/models/flow_step_model.dart';
// --- END IMPORT ---

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

// --- 2. MODIFIED: Converted to GetView<ReferralSummaryController> ---
class ReferralSummaryScreen extends GetView<ReferralSummaryController> {
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
    // Data is loaded by the controller's onInit

    return Scaffold(
      backgroundColor: _bgPage,
      body: Column(
        children: [
          /// ===== TOP STATUS STRIP =====
          Container(
            width: double.infinity,
            color: _tealStatus,
            padding: EdgeInsets.only(
              top: media.padding.top, // notch / status inset
              left: 24,
              right: 24,
              bottom: 12,
            ),
          ),

          /// ===== REST OF SCREEN SCROLLS =====
          Expanded(
            child: SingleChildScrollView(
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
                        Positioned.fill(
                          child: Container(color: _tealHeader),
                        ),
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
                                  const Text(
                                    'Earn \$189 each', // This is static promo text
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
                                        horizontal: 20,
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
                                    Image.asset(
                                      "assets/images/referral_coins.png",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- 3. MODIFIED: CREDIT SUMMARY CARD ---
                        Positioned(
                          left: 24,
                          right: 24,
                          top: 146,
                          child: Obx(() {
                            final wallet = controller.walletController.wallet.value;

                            // Important: make this dynamic so `is num` works properly
                            final dynamic raw = wallet?.usableBalance;

                            String credit;

                            if (raw == null) {
                              credit = '0';
                            } else if (raw is num) {
                              credit = raw.toStringAsFixed(0); // ✅ now valid
                            } else {
                              // raw is something else (likely String) -> try parse
                              final parsed = num.tryParse(raw.toString());
                              credit = parsed != null
                                  ? parsed.toStringAsFixed(0)
                                  : raw.toString();
                            }

                            final code = controller.referralCode.isNotEmpty
                                ? controller.referralCode
                                : '------';

                            return _CreditSummaryCard(
                              totalCredit: credit,
                              referralCode: code,
                            );
                          }),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ===== STEPS CALLOUT BOX =====
                  // --- 5. MODIFIED: Wrap in Obx for loading ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
                    child: Obx(() {
                      if (controller.isLoadingSteps.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _InviteStepsBox(steps: controller.steps);
                    }),
                  ),

                  const SizedBox(height: 24),

                  /// ===== FAQ SECTION =====
                  // --- 6. MODIFIED: Wrap in Obx for loading ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Obx(() {
                      if (controller.isLoadingFaqs.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _FaqSection(
                        faqs: controller.faqs,
                        controller: controller, // Pass controller for state
                      );
                    }),
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
class _CreditSummaryCard extends StatelessWidget {
  final String totalCredit;
  final String referralCode;

  const _CreditSummaryCard({
    required this.totalCredit,
    required this.referralCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderGrey, width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            right: 16,
            child: Opacity(
              opacity: 0.04,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: icon + total credit + share
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFC107),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total credit',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$$totalCredit',
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 28,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _cardBg.withOpacity(0.9),
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
                Container(
                  width: double.infinity,
                  height: 1,
                  color: _borderGrey,
                ),
                const SizedBox(height: 12),

                // Bottom row: referral code + copy
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Referral code',
                            style: TextStyle(
                              color: _textLabelGrey,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            referralCode,
                            style: const TextStyle(
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
                    GestureDetector(
                      onTap: () {
                        if (referralCode.isNotEmpty &&
                            referralCode != '------') {
                          Clipboard.setData(
                            ClipboardData(text: referralCode),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Referral code copied'),
                            ),
                          );
                        }
                      },
                      child: Container(
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


// --- 7. MODIFIED: _InviteStepsBox now takes dynamic data ---
class _InviteStepsBox extends StatelessWidget {
  final List<FlowStep> steps;
  const _InviteStepsBox({required this.steps});

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return const SizedBox.shrink(); // Don't show if no steps
    }

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
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            _StepRow(step: steps[i]),
            if (i < steps.length - 1) const SizedBox(height: 16),
          ]
        ],
      ),
    );
  }
}

// --- 8. MODIFIED: _StepRow now takes a FlowStep ---
class _StepRow extends StatelessWidget {
  final FlowStep step;
  const _StepRow({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          // --- Use NetworkImage for dynamic avatar ---
          child: (step.avatar != null && step.avatar!.isNotEmpty)
              ? Image.network(
            step.avatar!,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.link, size: 24, color: _tealHeader),
          )
              : const Icon(Icons.link, size: 24, color: _tealHeader),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            step.title, // <-- Use dynamic title
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 16,
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

// --- 9. MODIFIED: _FaqSection now takes dynamic data ---
class _FaqSection extends StatelessWidget {
  final List<Faq> faqs;
  final ReferralSummaryController controller; // To access expandedFaqIndex

  const _FaqSection({required this.faqs, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (faqs.isEmpty) {
      return const SizedBox.shrink(); // Don't show if no FAQs
    }

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

        // --- Loop over dynamic FAQs ---
        for (int i = 0; i < faqs.length; i++) ...[
          Obx(() {
            final isExpanded = controller.expandedFaqIndex.value == i;
            return isExpanded
                ? _FaqExpandedItem(
              faq: faqs[i],
              onTap: () => controller.toggleFaq(i),
            )
                : _FaqCollapsedItem(
              faq: faqs[i],
              onTap: () => controller.toggleFaq(i),
            );
          }),
          if (i < faqs.length - 1) const _FaqDivider(),
        ],
      ],
    );
  }
}

class _FaqDivider extends StatelessWidget {
  const _FaqDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      alignment: Alignment.topCenter,
      child: Container(
        height: 1,
        color: _borderGrey,
      ),
    );
  }
}


// --- 10. MODIFIED: _FaqExpandedItem ---
class _FaqExpandedItem extends StatelessWidget {
  final Faq faq;
  final VoidCallback onTap;
  const _FaqExpandedItem({required this.faq, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question, // <-- Dynamic
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  faq.answer, // <-- Dynamic
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
          _FaqIcon(expanded: true, onTap: onTap),
        ],
      ),
    );
  }
}

// --- 11. MODIFIED: _FaqCollapsedItem ---
class _FaqCollapsedItem extends StatelessWidget {
  final Faq faq;
  final VoidCallback onTap;
  const _FaqCollapsedItem({required this.faq, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                faq.question, // <-- Dynamic
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
            _FaqIcon(expanded: false, onTap: onTap),
          ],
        ),
      ),
    );
  }
}

// --- 12. MODIFIED: _FaqIcon ---
class _FaqIcon extends StatelessWidget {
  final bool expanded; // true => minus, false => plus
  final VoidCallback onTap;
  const _FaqIcon({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            size: 16,
            color: _tealHeader,
          ),
        ),
      ),
    );
  }
}