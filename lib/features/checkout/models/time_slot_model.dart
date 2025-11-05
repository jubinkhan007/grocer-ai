// lib/features/checkout/models/time_slot_model.dart
class TimeSlot {
  final int id;
  final String timeSlot;

  TimeSlot({required this.id, required this.timeSlot});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] ?? 0,
      timeSlot: json['time_slot'] ?? 'N/A',
    );
  }
}