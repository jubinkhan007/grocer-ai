// lib/features/products/models/product.dart
class Product {
  final int? id;                 // optional – backend may add later
  final String name;
  final String? category;
  final double? price;           // current (display) price
  final String? unitPrice;       // e.g. "$8.75/kg"
  final int? quantity;           // stock; 0 ⇒ show "N/A" badge
  final double? discount;        // optional; not required by current UI
  final String? image;           // URL
  final String? description;

  const Product({
    this.id,
    required this.name,
    this.category,
    this.price,
    this.unitPrice,
    this.quantity,
    this.discount,
    this.image,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as int?,
    name: (j['name'] ?? '').toString(),
    category: j['category']?.toString(),
    price: _toDouble(j['price']),
    unitPrice: j['unit_price']?.toString(),
    quantity: j['quantity'] is int ? j['quantity'] as int : null,
    discount: _toDouble(j['discount']),
    image: j['image']?.toString(),
    description: j['description']?.toString(),
  );

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().replaceAll(RegExp(r'[^0-9\.\-]'), '');
    return double.tryParse(s);
  }
}
