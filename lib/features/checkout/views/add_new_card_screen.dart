// lib/features/checkout/views/add_new_card_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/checkout/controllers/add_payment_method_controller.dart';
import '../utils/design_tokens.dart';

// --- MODIFIED: Converted to GetView<AddPaymentMethodController> ---
class AddNewCardScreen extends GetView<AddPaymentMethodController> {
  const AddNewCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- State is now handled in the main widget ---
    final _cardNumberCtrl = TextEditingController();
    final _cardNameCtrl = TextEditingController();
    final _expiryCtrl = TextEditingController();
    final _cvcCtrl = TextEditingController();
    final _saveCard = true.obs; // Default to true

    // The method ID (e.g., for 'stripe_card') is passed as an argument
    final int methodTypeId = Get.arguments as int;

    // same status bar style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: tealStatus,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: bgPage,
      body: Column(
        children: [
          _StatusBarStrip(),
          _TealHeader(
            title: 'Add new card',
            onBack: () => Get.back(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [
                  // Card number
                  _InputPill(
                    controller: _cardNumberCtrl,
                    hint: 'Enter card number',
                    icon: Icons.credit_card_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Card holder name
                  _InputPill(
                    controller: _cardNameCtrl,
                    hint: 'Enter card holder name',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),

                  // Row: Expire date | CVC/CVV2
                  Row(
                    children: [
                      Expanded(
                        child: _InputPill(
                          controller: _expiryCtrl,
                          hint: 'Expire date (MM/YY)',
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _InputPill(
                          controller: _cvcCtrl,
                          hint: 'CVC/CVV2',
                          icon: Icons.lock_outline,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // checkbox row
                  Obx(() => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          // Figma teal border/fill
                          activeColor: tealHeader,
                          side:
                          const BorderSide(color: tealHeader, width: 1),
                          value: _saveCard.value,
                          onChanged: (val) {
                            _saveCard.value = val ?? false;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Save your card information. It’s confidential.",
                          style: TextStyle(
                            color: textSecondary,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  )),

                  const SizedBox(height: 24),

                  // --- MODIFIED: Add button pill ---
                  _AddButtonPill(
                    enabled: true, // You can add validation logic here
                    onTap: () {
                      // In a real app, you'd get a token from Stripe/etc. here
                      // For simulation, we create a fake token.
                      final fakeToken =
                          "pm_sim_${DateTime.now().millisecondsSinceEpoch}";

                      // Call the controller to save this card
                      controller.saveNewCard(methodTypeId, fakeToken);
                    },
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

/// Big rounded 128 pill text field from Figma
class _InputPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int? maxLength;

  const _InputPill({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: const BorderRadius.all(pillRadius128),
        border: Border.all(
          color: fieldStrokeGrey,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: tealHeader,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              style: const TextStyle(
                color: textPrimary,
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: textSecondary,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width 56px pill at bottom ("Add")
/// Disabled state = gray pill
/// Enabled state = teal pill
class _AddButtonPill extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onTap;
  const _AddButtonPill({
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = enabled
        ? tealHeader
        : const Color(0xFF7F8E8F); // close to screenshot inactive gray

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: bgColor,
        borderRadius: const BorderRadius.all(pillRadius29),
        child: InkWell(
          borderRadius: const BorderRadius.all(pillRadius29),
          onTap: enabled ? onTap : null,
          child: const Center(
            child: Text(
              'Add',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: Color(0xFFFEFEFE),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// dark teal strip behind the OS status indicators, height ~48 in Figma set
class _StatusBarStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: tealStatus,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 0,
      ),
    );
  }
}

/// teal header row with back chevron + title
class _TealHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _TealHeader({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tealHeader,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFFFEFEFE),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.2,
              color: Color(0xFFFEFEFE),
            ),
          ),
        ],
      ),
    );
  }
}