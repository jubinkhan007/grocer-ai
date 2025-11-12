// lib/features/profile/models/partner_model.dart

class Partner {
  /// Relationship row id (this specific link)
  final int id;

  /// The actual partner user's id (from `partner.id`)
  final int partnerId;

  final String name;
  final String email;

  Partner({
    required this.id,
    required this.partnerId,
    required this.name,
    required this.email,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    final partnerField = json['partner'];

    // Case 1: list/GET shape -> nested partner object
    if (partnerField is Map<String, dynamic>) {
      return Partner(
        id: json['id'] ?? 0,
        partnerId: partnerField['id'] ?? 0,
        name: (partnerField['name'] ?? '').toString(),
        email: (partnerField['email'] ?? '').toString(),
      );
    }

    // Case 2: POST shape -> partner is just an id, maybe name/email on root
    if (partnerField is int) {
      return Partner(
        id: json['id'] ?? 0,
        partnerId: partnerField,
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
      );
    }

    // Fallback: use partner_id/name/email if present
    return Partner(
      id: json['id'] ?? 0,
      partnerId: (json['partner_id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'partner_id': partnerId,
    'name': name,
    'email': email,
  };
}
