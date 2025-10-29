import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/design_tokens.dart';
import 'add_new_card_screen.dart'; // we'll define below

class AddPaymentMethodScreen extends StatelessWidget {
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
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                children: [
                  _PaymentMethodRow(
                    label: 'Credit/Debit card',
                    leading: _FakeBrandIcon(color: tealHeader),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddNewCardScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _PaymentMethodRow(
                    label: 'Paypal',
                    leading: _FakeBrandIcon(color: Colors.blueGrey),
                    onTap: () {
                      // TODO: PayPal flow
                    },
                  ),
                  const SizedBox(height: 16),
                  _PaymentMethodRow(
                    label: 'Apple Pay',
                    leading: _FakeBrandIcon(color: Colors.black),
                    onTap: () {
                      // TODO: Apple Pay flow
                    },
                  ),
                  const SizedBox(height: 16),
                  _PaymentMethodRow(
                    label: 'Google Pay',
                    leading: _FakeBrandIcon(color: Colors.redAccent),
                    onTap: () {
                      // TODO: Google Pay flow
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

/// Single 56px pill row from Figma (white bg, radius 29, 0.5px border #E6EAEB)
class _PaymentMethodRow extends StatelessWidget {
  final String label;
  final Widget leading;
  final VoidCallback onTap;
  const _PaymentMethodRow({
    required this.label,
    required this.leading,
    required this.onTap,
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(child: leading),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  color: textPrimary,
                ),
              ),
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
