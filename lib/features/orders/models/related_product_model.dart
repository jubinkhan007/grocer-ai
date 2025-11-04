// lib/features/orders/models/related_product_model.dart

class RelatedProduct {
  final int id;
  final String name;
  final String category;
  final String price;        // "24.50"
  final String unitPrice;    // "$8.75/kg"
  final String quantity;     // "3.00"
  final int discount;        // 10
  final String image;        // URL
  final String description;

  RelatedProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unitPrice,
    required this.quantity,
    required this.discount,
    required this.image,
    required this.description,
  });

  factory RelatedProduct.fromJson(Map<String, dynamic> j) => RelatedProduct(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    category: j['category'] ?? '',
    price: j['price'] ?? '0.00',
    unitPrice: j['unit_price'] ?? '',
    quantity: j['quantity'] ?? '0.00',
    discount: j['discount'] ?? 0,
    image: j['image'] ?? '',
    description: j['description'] ?? '',
  );
}
