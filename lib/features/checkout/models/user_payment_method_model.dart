// lib/features/checkout/models/user_payment_method_model.dart
import 'package:grocer_ai/features/checkout/models/payment_method_model.dart';

class UserPaymentMethod {
  final int id;
  final String providerPaymentId; // e.g., 'pm_xxx' from Stripe
  final String? brand; // e.g., 'Visa'
  final String? last4; // e.g., '4242'
  final int? expMonth;
  final int? expYear;
  final bool isDefault;
  final PaymentMethod paymentMethod; // Nested payment method type

  UserPaymentMethod({
    required this.id,
    required this.providerPaymentId,
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
    required this.isDefault,
    required this.paymentMethod,
  });

  factory UserPaymentMethod.fromJson(Map<String, dynamic> json) {
    return UserPaymentMethod(
      id: json['id'] ?? 0,
      providerPaymentId: json['provider_payment_id'] ?? '',
      brand: json['brand'],
      last4: json['last4'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      isDefault: json['is_default'] ?? false,
      paymentMethod: PaymentMethod.fromJson(json['payment_method'] ?? {}),
    );
  }
}