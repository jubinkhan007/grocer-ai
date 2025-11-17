// lib/features/checkout/services/checkout_service.dart


import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/checkout/models/payment_method_model.dart';
import 'package:grocer_ai/features/checkout/models/time_slot_model.dart';
import 'package:grocer_ai/features/checkout/models/user_payment_method_model.dart';
import 'package:grocer_ai/features/orders/models/create_order_request.dart';
import '../../orders/models/order_models.dart';

class CheckoutService {
  final DioClient _client;
  CheckoutService(this._client);


  ApiFailure _asFailure(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    String _fromMap(Map m) {
      // 1) common keys
      if (m['detail'] is String) return m['detail'] as String;
      if (m['message'] is String) return m['message'] as String;

      // 2) non_field_errors: ["..."]
      final nfe = m['non_field_errors'];
      if (nfe is List && nfe.isNotEmpty) {
        return nfe.map((x) => x.toString()).join('\n');
      }

      // 3) first field error: {field: ["..."]} or {field: "..."}
      for (final entry in m.entries) {
        final v = entry.value;
        if (v is List && v.isNotEmpty) {
          return v.map((x) => x.toString()).join('\n');
        }
        if (v is String) return v;
      }

      // 4) fallback
      return m.toString();
    }

    String message;
    if (data is Map) {
      message = _fromMap(data);
    } else if (data is List) {
      message = data.map((x) => x.toString()).join('\n');
    } else {
      message = e.message ?? 'Request failed';
    }

    // If you have a different ApiFailure ctor, adapt this line accordingly:
    return ApiFailure(message: message);
  }


  Future<Order> createOrder(CreateOrderRequest request) async {
    try {
      final res = await _client.postJson(ApiPath.orders, request.toJson());
      return Order.fromJson(res.data);
    } on DioException catch (e) {
      throw _asFailure(e);  // <-- changed
    }
  }

  Future<List<TimeSlot>> fetchTimeSlots() async {
    try {
      final res = await _client.getJson<List<dynamic>>(ApiPath.timeSlots);
      return (res.data ?? [])
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asFailure(e);  // <-- changed
    }
  }

  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    try {
      final res = await _client.getJson<List<dynamic>>(ApiPath.paymentMethods);
      return (res.data ?? [])
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asFailure(e);  // <-- changed
    }
  }

  Future<List<UserPaymentMethod>> fetchUserPaymentMethods() async {
    try {
      final res = await _client.getJson(ApiPath.userPaymentMethods);
      final data = res.data['results'] as List? ?? [];
      return data
          .map((e) => UserPaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _asFailure(e);  // <-- changed
    }
  }

  Future<UserPaymentMethod> saveUserPaymentMethod({
    required int paymentMethodId,
    required String providerPaymentId,
  }) async {
    try {
      final res = await _client.postJson(ApiPath.userPaymentMethods, {
        'provider_payment_method_id': providerPaymentId,
        'payment_method': paymentMethodId,
      });
      return UserPaymentMethod.fromJson(res.data);
    } on DioException catch (e) {
      throw _asFailure(e);  // <-- changed
    }
  }

  Future<void> deleteUserPaymentMethod(int id) async {
    try {
      await _client.deleteJson('${ApiPath.userPaymentMethodDetail}$id/');
    } on DioException catch (e) {
      throw _asFailure(e);  // <-- changed
    }
  }

  Future<void> payForOrder({
    required int orderId,
    required int userPaymentMethodId,
  }) async {
    try {
      await _client.postJson(ApiPath.orderPay, {
        'order_id': orderId,
        'user_payment_method_id': userPaymentMethodId,
      });
    } on DioException catch (e) {
      throw _asFailure(e);  // <-- changed
    }
  }
}
