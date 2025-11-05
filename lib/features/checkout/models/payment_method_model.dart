// lib/features/checkout/models/payment_method_model.dart
class PaymentMethod {
  final int id;
  final String name; // e.g., 'Credit/Debit Card'
  final String key; // e.g., 'stripe_card'
  final String? icon; // URL

  PaymentMethod({
    required this.id,
    required this.name,
    required this.key,
    this.icon,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      icon: json['icon'],
    );
  }
}