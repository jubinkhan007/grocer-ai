// lib/features/checkout/views/add_payment_method_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/features/checkout/controllers/add_payment_method_controller.dart';
import 'package:grocer_ai/features/checkout/controllers/checkout_controller.dart';
import '../utils/design_tokens.dart';

// --- MODIFIED: Converted to GetView<AddPaymentMethodController> ---
class AddPaymentMethodScreen extends GetView<AddPaymentMethodController> {
  const AddPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // light icons on dark #002C2E status strip
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
            title: 'Add payment method',
            onBack: () => Get.back(),
          ),
          // --- MODIFIED: Added Obx for loading state ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- MODIFIED: Dynamic list of SAVED methods ---
                    if (controller.userPaymentMethods.isNotEmpty) ...[
                      const Text(
                        "Saved Methods",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary),
                      ),
                      const SizedBox(height: 12),
                      ...controller.userPaymentMethods.map((method) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _PaymentMethodRow(
                            label:
                            "${method.brand ?? 'Card'} ending in ${method.last4 ?? '....'}",
                            leading: _FakeBrandIcon(
                                color: (method.brand?.toLowerCase() == 'visa')
                                    ? Colors.blue
                                    : Colors.orange),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: errorRed),
                              onPressed: () => controller.deleteMethod(method.id),
                            ),
                            onTap: () {
                              // Select this card and go back
                              Get.find<CheckoutController>()
                                  .selectPaymentMethod(method.id);
                              Get.back();
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],

                    // --- MODIFIED: Dynamic list of NEW method types ---
                    const Text(
                      "Add New Method",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimary),
                    ),
                    const SizedBox(height: 12),
                    ...controller.paymentMethodTypes.map((methodType) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PaymentMethodRow(
                          label: methodType.name,
                          leading: _FakeBrandIcon(color: tealHeader),
                          onTap: () => controller.handleAddNewMethod(methodType),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ),
        ],
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

/// --- MODIFIED: Single 56px pill row, now accepts a trailing widget ---
class _PaymentMethodRow extends StatelessWidget {
  final String label;
  final Widget leading;
  final Widget? trailing; // <-- NEW
  final VoidCallback onTap;
  const _PaymentMethodRow({
    required this.label,
    required this.leading,
    required this.onTap,
    this.trailing, // <-- NEW
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: pillBg,
      borderRadius: const BorderRadius.all(pillRadius29),
      child: InkWell(
        borderRadius: const BorderRadius.all(pillRadius29),
        onTap: onTap,
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(pillRadius29),
            border: Border.all(
              color: chipBorderGrey,
              width: 0.5,
            ),
            color: pillBg,
          ),
          padding: const EdgeInsets.only(left: 16), // <-- MODIFIED
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(child: leading),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    color: textPrimary,
                  ),
                ),
              ),
              if (trailing != null) trailing!, // <-- NEW
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder square for the left brand icon in Figma.
/// Replace with real svg/png logos later.
class _FakeBrandIcon extends StatelessWidget {
  final Color color;
  const _FakeBrandIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.credit_card, // swap per row if you like
      size: 20,
      color: color,
    );
  }
}