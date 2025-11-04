import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/design_tokens.dart';
import '../utils/enums.dart';
import '../widgets/add_payment_method_card.dart';
import '../widgets/address_card.dart';
import '../widgets/checkout_header.dart';
import '../widgets/credit_redemtion_details.dart';
import '../widgets/credit_redemtion_toggle.dart';
import '../widgets/fulfillment_method_card.dart';
import '../widgets/invoice_card.dart';
import '../widgets/pay_cta.dart';
import '../widgets/timing_card.dart';
import 'add_change_location.dart';
import 'add_payment_method_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // STATE HOOKS mirroring the 3 mocks
  RedemptionUIState redemptionState = RedemptionUIState.off;
  String fulfillment = 'pickup'; // or 'delivery'
  String selectedSlot = '10 AM - 11 AM';

  @override
  void initState() {
    super.initState();
    // status bar style (light icons over dark teal strip)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: tealStatus,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  bool get _creditEnabled =>
      redemptionState == RedemptionUIState.empty ||
          redemptionState == RedemptionUIState.filled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPage,
      body: Column(
        children: [
          // header at top (status + teal app bar)
          CheckoutHeader(
            onBack: () {
              Navigator.of(context).maybePop();
            },
          ),

          // content scrolls
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Credit Redemption toggle card
                  CreditRedemptionToggleCard(
                    enabled: _creditEnabled,
                    onChanged: (val) {
                      setState(() {
                        if (!val) {
                          redemptionState = RedemptionUIState.off;
                        } else {
                          // default to EMPTY when turning on
                          redemptionState = RedemptionUIState.empty;
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // 2. Redemption details (only if ON)
                  if (_creditEnabled) ...[
                    CreditRedemptionDetailsCard(
                      uiState: redemptionState,
                      availableAmount: '11.23',
                      maxAmount: '6.50',
                      enteredAmount:
                      redemptionState == RedemptionUIState.filled
                          ? '6.50'
                          : '',
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 3. Add payment method row card
                  AddPaymentMethodCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddPaymentMethodScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 4. Get Stuffs by (pickup / delivery pills)
                  FulfillmentMethodCard(
                    selected: fulfillment,
                    onSelect: (v) {
                      setState(() {
                        fulfillment = v;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // 5. Delivery address card
                  AddressCard(
                    address:
                    '1234 Maple Street, Springfield, IL 62704, USA',
                    onChange: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SetNewLocationScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 6. Timing grid card
                  TimingCard(
                    selectedSlot: selectedSlot,
                    onSelect: (slot) {
                      setState(() {
                        selectedSlot = slot;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // 7. Checkout invoice
                  const InvoiceCard(),

                  const SizedBox(height: 120), // breathing room above CTA
                ],
              ),
            ),
          ),

          // sticky CTA at bottom
          PayCTA(
            onTap: () {
              // Navigate to the CongratulationsScreen when the button is pressed
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CongratulationsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // FAB or bottom nav is NOT present in the Figma checkout frame,
      // so we keep this Screen clean.
    );
  }
}
