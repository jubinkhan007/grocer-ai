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

  /// POST /api/v1/orders/ (NEW)
  Future<Order> createOrder(CreateOrderRequest request) async {
    try {
      final res = await _client.postJson(ApiPath.orders, request.toJson());
      return Order.fromJson(res.data);
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// GET /api/v1/time-slots/
  Future<List<TimeSlot>> fetchTimeSlots() async {
    try {
      final res = await _client.getJson<List<dynamic>>(ApiPath.timeSlots);
      return (res.data ?? [])
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// GET /api/v1/payment-methods/
  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    try {
      final res =
      await _client.getJson<List<dynamic>>(ApiPath.paymentMethods);
      return (res.data ?? [])
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// GET /api/v1/user-payment-methods/
  Future<List<UserPaymentMethod>> fetchUserPaymentMethods() async {
    try {
      final res =
      await _client.getJson(ApiPath.userPaymentMethods);
      // Assuming paginated response
      final data = res.data['results'] as List? ?? [];
      return data
          .map((e) => UserPaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// POST /api/v1/user-payment-methods/
  Future<UserPaymentMethod> saveUserPaymentMethod({
    required int paymentMethodId,
    required String providerPaymentId, // e.g., "pm_xxx" from Stripe
    bool isDefault = true,
  }) async {
    try {
      final res = await _client.postJson(
        ApiPath.userPaymentMethods,
        {
          'payment_method_id': paymentMethodId,
          'provider_payment_id': providerPaymentId,
          'is_default': isDefault,
        },
      );
      return UserPaymentMethod.fromJson(res.data);
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// DELETE /api/v1/user-payment-methods/{id}/
  Future<void> deleteUserPaymentMethod(int id) async {
    try {
      await _client.deleteJson('${ApiPath.userPaymentMethodDetail}$id/');
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// POST /api/v1/order-pay/
  Future<void> payForOrder({
    required int orderId,
    required int userPaymentMethodId,
  }) async {
    try {
      await _client.postJson(
        ApiPath.orderPay,
        {
          'order_id': orderId,
          'user_payment_method_id': userPaymentMethodId,
        },
      );
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}