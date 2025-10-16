class Referral {
  final int id;
  final String name;
  final String email;
  final String status;
  final double amount;
  final DateTime? createdAt;

  Referral({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.amount,
    this.createdAt,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
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
