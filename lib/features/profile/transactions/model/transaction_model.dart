// lib/features/profile/transactions/model/transaction_model.dart
import 'package:intl/intl.dart';

class ProfilePaymentTransaction {
  final int id;
  // --- FIX: Changed from OrderTitle to int ---
  final int orderId;
  final String? transactionId;
  // --- FIX: Changed from UserPaymentMethodTitle to int ---
  final int userPaymentMethodId;
  final String amount;
  final String status; // 'pending', 'paid', 'failed', 'refunded'
  final String createdAt;

  ProfilePaymentTransaction({
    required this.id,
    required this.orderId, // <-- MODIFIED
    this.transactionId,
    required this.userPaymentMethodId, // <-- MODIFIED
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory ProfilePaymentTransaction.fromJson(Map<String, dynamic> json) {
    return ProfilePaymentTransaction(
      id: json['id'] ?? 0,
      // --- FIX: Parse as int ---
      orderId: json['order'] ?? 0,
      transactionId: json['transaction_id'],
      // --- FIX: Parse as int ---
      userPaymentMethodId: json['user_payment_method'] ?? 0,
      amount: (json['amount'] ?? '0.00').toString(),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }

  // Helper for grouping
  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return 'Unknown Date';
    }
  }

  // Helper for detail screen
  String get formattedDateTime {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('dd MMM yyyy • h:mma').format(date);
    } catch (e) {
      return createdAt;
    }
  }
}

// --- The classes below are no longer used by this model ---
// --- You can leave them or remove them, but they are not used ---
// --- for the transaction list. ---

class OrderTitle {
  final int id;
  final String? deliveredAt;
  OrderTitle({required this.id, this.deliveredAt});

  factory OrderTitle.fromJson(Map<String, dynamic> json) {
    return OrderTitle(
      id: json['id'] ?? 0,
      deliveredAt: json['delivered_at'],
    );
  }
}

class UserPaymentMethodTitle {
  final int id;
  final PaymentMethodTitle paymentMethod;
  final String? brand;

  UserPaymentMethodTitle(
      {required this.id, required this.paymentMethod, this.brand});

  factory UserPaymentMethodTitle.fromJson(Map<String, dynamic> json) {
    return UserPaymentMethodTitle(
      id: json['id'] ?? 0,
      paymentMethod:
      PaymentMethodTitle.fromJson(json['payment_method'] ?? {}),
      brand: json['brand'],
    );
  }

  String get displayName {
    if (brand != null && brand!.isNotEmpty) {
      return brand!;
    }
    return paymentMethod.name;
  }
}

class PaymentMethodTitle {
  final int id;
  final String name;
  final String key;

  PaymentMethodTitle({required this.id, required this.name, required this.key});

  factory PaymentMethodTitle.fromJson(Map<String, dynamic> json) {
    return PaymentMethodTitle(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      key: json['key'] ?? '',
    );
  }
}