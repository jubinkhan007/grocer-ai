// lib/features/offer/data/product_model.dart

class ProductListResponse {
  final int count;
  final List<Product> results;

  ProductListResponse({required this.count, required this.results});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Product> resultsList = list.map((i) => Product.fromJson(i)).toList();
    return ProductListResponse(
      count: json['count'],
      results: resultsList,
    );
  }
}

class Product {
  final int id;
  final String name;
  final String category;
  final String price;
  final int discount;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.discount,
    required this.image,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      discount: json['discount'],
      image: json['image'],
      description: json['description'],
    );
  }
}