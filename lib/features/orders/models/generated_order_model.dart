// lib/features/orders/models/generated_order_model.dart
// NEW FILE
import 'dart:convert';

import 'package:get/get.dart';

// Helper function to safely parse doubles
double _safeParseDouble(dynamic val, [double fallback = 0.0]) {
  if (val == null) return fallback;
  if (val is double) return val;
  if (val is int) return val.toDouble();
  return double.tryParse(val.toString()) ?? fallback;
}

// Helper function to safely parse integers
int _safeParseInt(dynamic val, [int fallback = 0]) {
  if (val == null) return fallback;
  if (val is int) return val;
  if (val is double) return val.toInt();
  return int.tryParse(val.toString()) ?? fallback;
}

class GeneratedOrderResponse {
  final ProviderData provider;
  final List<ProductData> products;

  GeneratedOrderResponse({required this.provider, required this.products});

  factory GeneratedOrderResponse.fromJson(Map<String, dynamic> json) {
    return GeneratedOrderResponse(
      provider: ProviderData.fromJson(json['provider'] ?? {}),
      products: (json['products'] as List? ?? [])
          .map((e) => ProductData.fromJson(e))
          .toList(),
    );
  }
}

class ProviderData {
  final int id;
  final String name;
  final String logo;
  final String totalPrice;
  final String discountedPrice;
  final int totalItems;

  ProviderData({
    required this.id,
    required this.name,
    required this.logo,
    required this.totalPrice,
    required this.discountedPrice,
    required this.totalItems,
  });

  factory ProviderData.fromJson(Map<String, dynamic> json) {
    return ProviderData(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Store',
      logo: json['logo'] ?? '',
      totalPrice: json['total_price'] ?? '0.00',
      discountedPrice: json['discounted_price'] ?? '0.00',
      totalItems: json['total_items'] ?? 0,
    );
  }
}

class ProductData {
  final int id;
  final String name;
  final String category;
  final String price; // Total price (quantity * unit_price after discount)
  final String unit;
  final String unitPrice; // Price per unit
  final String quantity; // e.g., "3.00"
  final int discount; // e.g., 10 (for 10%)
  final String image;
  final String description;

  // Local state for UI
  RxInt uiQuantity;

  ProductData({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.unitPrice,
    required this.quantity,
    required this.discount,
    required this.image,
    required this.description,
  }) : uiQuantity = _safeParseInt(quantity, 1).obs; // Initialize RxInt

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Product',
      category: json['category'] ?? '',
      price: json['price'] ?? '0.00',
      unit: json['unit'] ?? 'unit',
      unitPrice: json['unit_price'] ?? '\$0.00',
      quantity: json['quantity'] ?? '0.00',
      discount: json['discount'] ?? 0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Helper to format the unit string
  String get pricePerUnit {
    return '$unitPrice/${unit}';
  }
}