// lib/features/orders/models/create_order_request.dart
// This model is the payload for POST /api/v1/orders/
import 'package:grocer_ai/features/orders/models/generated_order_model.dart';

class CreateOrderRequest {
  final int providerId;
  final String price;
  final String discount;
  final String redeemFromWallet;
  final int totalItems;
  final String deliveryMethod;
  final int deliverySlotId;
  final int deliveryAddressId; // Using ID for the saved location
  final List<ProductData> products;

  CreateOrderRequest({
    required this.providerId,
    required this.price,
    required this.discount,
    required this.redeemFromWallet,
    required this.totalItems,
    required this.deliveryMethod,
    required this.deliverySlotId,
    required this.deliveryAddressId,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': providerId, // API expects 'provider' field
      'price': price,
      'discount': discount,
      'redeem_from_wallet': redeemFromWallet,
      'total_items': totalItems,
      'delivery_method': deliveryMethod,
      'delivery_slot': deliverySlotId,
      'delivery_address_id': deliveryAddressId, // API needs to accept this
      'order_data': products.map((p) => {
        'id': p.id,
        'name': p.name,
        'quantity': p.uiQuantity.value,
        'price': p.price,
        'unit_price': p.unitPrice,
      }).toList(),
    };
  }
}