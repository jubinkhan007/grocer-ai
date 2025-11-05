// lib/features/onboarding/location/models/user_location_model.dart
class UserLocation {
  final int id;
  final String label;
  final String address;
  final double? latitude;
  final double? longitude;

  UserLocation({
    required this.id,
    required this.label,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      id: json['id'] ?? 0,
      label: json['label'] ?? 'Unknown',
      address: json['address'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
    );
  }
}