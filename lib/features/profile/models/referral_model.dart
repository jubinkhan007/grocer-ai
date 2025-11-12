// lib/features/profile/models/referral_model.dart

// Represents the "UserSearch" schema nested inside 'referred'
class ReferredUser {
  final int id;
  final String? name;
  final String email;
  final String? avatar;

  ReferredUser({
    required this.id,
    this.name,
    required this.email,
    this.avatar,
  });

  factory ReferredUser.fromJson(Map<String, dynamic> json) {
    return ReferredUser(
      id: json['id'] ?? 0,
      name: json['name'],
      email: json['email'] ?? '',
      avatar: json['avatar'],
    );
  }
}

class Referral {
  final int id; // <-- 1. THIS IS THE FIX for the controller error
  final String? name;
  final String? email;
  final String status;
  final String? avatar;
  final ReferredUser referred;
  final double amount; // Parsed from "earned"
  final DateTime? createdAt; // Parsed from "updated_at"

  Referral({
    required this.id, // <-- Added
    this.name,
    this.email,
    required this.status,
    this.avatar,
    required this.referred,
    required this.amount,
    this.createdAt,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'] ?? 0, // <-- 2. PARSE THE ID

      // Top-level fields
      name: json['name'],
      email: json['email'],
      status: json['status'] ?? 'invited',
      avatar: json['avatar'],

      // Nested 'referred' object
      referred: ReferredUser.fromJson(json['referred'] ?? {}),

      // Renamed/Type-casted fields
      amount: double.tryParse(json['earned']?.toString() ?? '0.0') ?? 0.0,
      createdAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'status': status,
    'amount': amount,
  };
}
