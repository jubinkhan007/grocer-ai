// lib/features/orders/models/order_models.dart

import 'package:grocer_ai/features/orders/models/order_data_item_model.dart';

import '../../offer/data/provider_model.dart';

class OrderItem {
  final int id;
  final String emoji;
  final String title;
  final String pricePer;
  final String price;
  int qty;

  OrderItem({
    required this.id,
    required this.emoji,
    required this.title,
    required this.pricePer,
    required this.price,
    this.qty = 3,
  });
}

// ... (mockItems and related lists remain the same) ...
final mockItems = <OrderItem>[
  OrderItem(id: 1, emoji: '🍜', title: 'Royal Basmati Rice', pricePer: '\$8.75/kg', price: '\$26.25'),
  OrderItem(id: 2, emoji: '🧴', title: 'Sunny Valley Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 3, emoji: '🧺', title: 'Golden Harvest Quinoa', pricePer: '\$4.29/kg', price: '\$42.7'),
  OrderItem(id: 4, emoji: '🍯', title: 'Maple Grove Honey', pricePer: '\$12.50/kg', price: '\$34.7'),
  OrderItem(id: 5, emoji: '🧂', title: 'Emerald Isle Sea Salt', pricePer: '\$5.50/kg', price: '\$28.3'),
  OrderItem(id: 6, emoji: '🥤', title: 'Crisp Apple Juice', pricePer: '\$3.49/litter', price: '\$31.4'),
  OrderItem(id: 7, emoji: '☕️', title: 'Mountain Coffee Beans', pricePer: '\$12.99/kg', price: '\$19.6'),
];

final related = <OrderItem>[
  OrderItem(id: 21, emoji: '🧴', title: 'Mediterranean Breeze Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 22, emoji: '🧴', title: 'Verdant Valley Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 23, emoji: '🧴', title: 'Golden Fields Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 24, emoji: '🧴', title: 'Maple Leaf Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
];

// This model represents a created order from POST /api/v1/orders/
// or GET /api/v1/orders/{id}/ or GET /api/v1/orders/last-active/
class Order {
  final int id;
  final String orderId;
  final String price;
  final String? discount;
  final String? redeemFromWallet;
  final int totalItems; // <-- ADDED
  final String status;
  final String deliveryMethod;
  final String? deliveryTime; // <-- ADDED
  final String deliveryAddress;
  final DateTime createdAt;
  final Provider? provider;
  final List<OrderDataItem> items;

  Order({
    required this.id,
    required this.orderId,
    required this.price,
    this.discount,
    this.redeemFromWallet,
    required this.totalItems, // <-- ADDED
    required this.status,
    required this.deliveryMethod,
    this.deliveryTime, // <-- ADDED
    required this.deliveryAddress,
    required this.createdAt,
    this.provider,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    Provider? provider;
    List<OrderDataItem> items = [];

    // Check for provider at top level (from OrderList)
    if (json['provider'] != null) {
      provider = Provider.fromJson(json['provider']);
    }

    // Check for provider and items nested in order_data (from Order detail)
    if (json['order_data'] is Map) {
      final orderData = json['order_data'] as Map<String, dynamic>;
      if (orderData['provider'] != null) {
        provider = Provider.fromJson(orderData['provider']);
      }
      if (orderData['items'] is List) {
        items = (orderData['items'] as List)
            .map((item) => OrderDataItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    return Order(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      price: json['price'] ?? '0.00',
      discount: json['discount'],
      redeemFromWallet: json['redeem_from_wallet'],
      totalItems: json['total_items'] ?? items.length, // <-- ADDED (fallback to items.length)
      status: json['status']?.toString() ?? 'pending',
      deliveryMethod: json['delivery_method'] ?? '',
      deliveryTime: json['delivery_time'], // <-- ADDED
      deliveryAddress: json['delivery_address'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      provider: provider,
      items: items,
    );
  }
}