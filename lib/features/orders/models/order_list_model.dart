// lib/features/orders/models/order_list_model.dart
import 'package:grocer_ai/features/offer/data/provider_model.dart';
import 'package:grocer_ai/features/orders/models/order_status_model.dart';
import 'package:intl/intl.dart';
import 'package:grocer_ai/features/checkout/models/time_slot_model.dart';

// This model is based on the `OrderList` schema in the API spec
class OrderList {
  final int id;
  final String orderId;
  final String price;
  final String? discount;
  final int totalItems;
  final OrderStatusModel status;
  final String deliveryMethod;
  final TimeSlot? deliverySlot;
  final dynamic orderData; // This is just JSON in the spec

  // --- ASSUMED FIELD ---
  // This field is not in the spec, but is required by the UI.
  // We assume the API provides it, similar to CompareGrocery.
  final Provider? provider;

  // --- ADDED FIELD ---
  // The API spec for `OrderList` doesn't include `created_at`, but
  // the history UI needs it for grouping.
  // The `Order` object *does* have it. We'll assume `OrderList` has it too.
  final DateTime createdAt;

  OrderList({
    required this.id,
    required this.orderId,
    required this.price,
    this.discount,
    required this.totalItems,
    required this.status,
    required this.deliveryMethod,
    this.deliverySlot,
    this.orderData,
    this.provider,
    required this.createdAt,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      price: json['price'] ?? '0.00',
      discount: json['discount'],
      totalItems: json['total_items'] ?? 0,
      status: OrderStatusModel.fromJson(json['status'] ?? {}),
      deliveryMethod: json['delivery_method'] ?? 'unknown',
      deliverySlot: json['delivery_slot'] != null
          ? TimeSlot.fromJson(json['delivery_slot'])
          : null,
      orderData: json['order_data'],
      provider: json['provider'] != null
          ? Provider.fromJson(json['provider'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  // Helper for grouping
  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(createdAt);
  }
}