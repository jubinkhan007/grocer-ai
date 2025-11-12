// lib/features/profile/models/partner_search_user.dart
class PartnerSearchUser {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  PartnerSearchUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory PartnerSearchUser.fromJson(Map<String, dynamic> json) {
    return PartnerSearchUser(
      id: json['id'] as int,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      avatar: json['avatar'] as String?,
    );
  }
}
