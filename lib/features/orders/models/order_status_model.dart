// lib/features/orders/models/order_status_model.dart
class OrderStatusModel {
  final int id;
  final String name;
  final String displayName;
  final String? color;

  OrderStatusModel({
    required this.id,
    required this.name,
    required this.displayName,
    this.color,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'unknown',
      displayName: json['display_name'] ?? 'Unknown',
      color: json['color'],
    );
  }
}