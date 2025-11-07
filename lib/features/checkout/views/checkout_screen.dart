// lib/features/checkout/views/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/features/checkout/controllers/checkout_controller.dart';
import '../models/user_payment_method_model.dart';
import '../utils/design_tokens.dart';
import '../utils/enums.dart';
import '../widgets/add_payment_method_card.dart';
import '../widgets/address_card.dart';
import '../widgets/card_shell.dart' as card;
import '../widgets/checkout_header.dart';
import '../widgets/credit_redemtion_details.dart';
import '../widgets/credit_redemtion_toggle.dart';
import '../widgets/fulfillment_method_card.dart';
import '../widgets/invoice_card.dart';
import '../widgets/pay_cta.dart';
import '../widgets/timing_card.dart';
import 'add_change_location.dart';
// import 'add_change_location.dart'; // No longer needed

// --- MODIFIED: Converted to GetView<CheckoutController> ---
class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // status bar style (light icons over dark teal strip)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: tealStatus,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: bgPage,
      body: Column(
        children: [
          // header at top (status + teal app bar)
          CheckoutHeader(
            onBack: () => Get.back(),
          ),

          // --- MODIFIED: Added Obx for loading state ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Determine RedemptionUIState from controller
              final RedemptionUIState redemptionState;
              if (!controller.creditEnabled.value) {
                redemptionState = RedemptionUIState.off;
              } else {
                // TODO: Add logic for 'filled' state if you implement amount input
                redemptionState = RedemptionUIState.empty;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120), // Added padding for CTA
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Credit Redemption toggle card
                    CreditRedemptionToggleCard(
                      enabled: controller.creditEnabled.value,
                      onChanged: (val) => controller.toggleCredit(val),
                    ),

                    const SizedBox(height: 20),

                    // 2. Redemption details (only if ON)
                    if (controller.creditEnabled.value) ...[
                      CreditRedemptionDetailsCard(
                        uiState: redemptionState,
                        availableAmount: '0.00', // TODO: Get from controller
                        maxAmount: '0.00', // TODO: Get from controller
                        enteredAmount: '', // TODO: Get from controller
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ---
                    //
                    // THIS IS THE FIX
                    //
                    // ---
                    // --- MODIFIED: Show selected payment method ---
                    // --- FIX: Removed the extra .value ---
                    if (controller.selectedPaymentMethod != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildSelectedPaymentMethod(
                            controller.selectedPaymentMethod!),
                      ),
                    // --- END FIX ---

                    // 3. Add payment method row card
                    AddPaymentMethodCard(
                      onTap: () => Get.toNamed(Routes.addPaymentMethod),
                    ),

                    const SizedBox(height: 20),

                    // 4. Get Stuffs by (pickup / delivery pills)
                    FulfillmentMethodCard(
                      selected: controller.fulfillmentMethod.value,
                      onSelect: (v) => controller.setFulfillmentMethod(v),
                    ),

                    const SizedBox(height: 20),

                    // 5. Delivery address card
                    Obx(() {
                      final c = Get.find<CheckoutController>();
                      final address = c.selectedLocation?.address ?? 'Select delivery address';

                      return AddressCard(
                        address: address,
                        onChange: () {
                          // Navigate to SetNewLocationScreen
                          Get.to(() => const SetNewLocationScreen());
                        },
                      );
                    }),

                    const SizedBox(height: 20),

                    // 6. Timing grid card
                    TimingCard(
                      // Pass the list of strings from the controller
                      slots: controller.timeSlots
                          .map((ts) => ts.timeSlot)
                          .toList(),
                      selectedSlot: controller.selectedTimeSlotLabel,
                      onSelect: (slotLabel) {
                        controller.selectTimeSlotByLabel(slotLabel);
                      },
                    ),

                    const SizedBox(height: 20),

                    // 7. --- MODIFIED: Dynamic Checkout invoice ---
                    InvoiceCard(
                      orderValue: controller.orderValue,
                      redeemedValue: controller.redeemedValue,
                      dueToday: controller.dueToday,
                      total: controller.totalValue,
                    ),
                  ],
                ),
              );
            }),
          ),

          // sticky CTA at bottom
          Obx(() => PayCTA(
            isLoading: controller.isPlacingOrder.value,
            onTap: controller.proceedToPay,
          )),
        ],
      ),
    );
  }

  // Helper widget to show the selected payment card
  Widget _buildSelectedPaymentMethod(UserPaymentMethod method) {
    return card.Card(
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: tealHeader),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${method.brand ?? 'Card'} ending in ${method.last4 ?? '....'}",
              style: const TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.addPaymentMethod),
            child: const Text(
              'Change',
              style: TextStyle(
                color: linkTeal,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}