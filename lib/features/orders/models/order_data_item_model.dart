// lib/features/orders/models/order_data_item_model.dart
class OrderDataItem {
  final String name;
  final num quantity;
  final String unit;
  final String unitPrice;
  final num discount;
  final num price;

  OrderDataItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.discount,
    required this.price,
  });

  factory OrderDataItem.fromJson(Map<String, dynamic> json) {
    return OrderDataItem(
      name: json['name'] ?? 'Unknown Item',
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? 'unit',
      unitPrice: json['unit_price'] ?? '\$0.00',
      discount: json['discount'] ?? 0,
      price: json['price'] ?? 0.0,
    );
  }
}