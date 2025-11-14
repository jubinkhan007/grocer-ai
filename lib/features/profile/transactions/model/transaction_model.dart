// lib/features/profile/transactions/model/transaction_model.dart
import 'package:intl/intl.dart';

class ProfilePaymentTransaction {
  final int id;
  final int orderId;
  final int userPaymentMethodId;
  final String? transactionId;
  final String amount;
  final String status;
  final String createdAt;

  ProfilePaymentTransaction({
    required this.id,
    required this.orderId,
    required this.userPaymentMethodId,
    this.transactionId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  // NEW: tolerant int extractor (handles int / string / {id: ...} / null)
  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is Map<String, dynamic>) return _asInt(v['id']);
    return 0;
  }

  factory ProfilePaymentTransaction.fromJson(Map<String, dynamic> json) {
    return ProfilePaymentTransaction(
      id: _asInt(json['id']),
      orderId: _asInt(json['order']),                        // ✅ handles map or id
      userPaymentMethodId: _asInt(json['user_payment_method']), // ✅ handles map or id
      transactionId: json['transaction_id']?.toString(),
      amount: (json['amount'] ?? '0.00').toString(),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return 'Unknown Date';
    }
  }

  String get formattedDateTime {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('dd MMM yyyy • h:mma').format(date);
    } catch (_) {
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