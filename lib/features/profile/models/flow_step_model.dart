// lib/features/profile/models/flow_step_model.dart
class FlowStep {
  final int id;
  final String type;
  final String title;
  final String? avatar; // This is a URL
  final int serialNumber;

  FlowStep({
    required this.id,
    required this.type,
    required this.title,
    this.avatar,
    required this.serialNumber,
  });

  factory FlowStep.fromJson(Map<String, dynamic> json) {
    return FlowStep(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      avatar: json['avatar'],
      serialNumber: json['serial_number'] ?? 0,
    );
  }
}