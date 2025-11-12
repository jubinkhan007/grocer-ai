// lib/features/orders/services/order_service.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/orders/models/order_list_model.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart'; // For Order

class OrderService {
  final DioClient _client;
  OrderService(this._client);

  /// GET /api/v1/orders/last-active/
  /// Returns the user's last active (not cancelled/completed) order.
  /// Returns null if API returns 404 (No active order).
  Future<Order?> fetchCurrentOrder() async {
    try {
      final res = await _client.getJson(ApiPath.orderLastActive);
      return Order.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // If 404, it just means no active order, not an error.
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// GET /api/v1/orders/ (Paginated)
  /// Fetches all historical orders.
  Future<List<OrderList>> fetchOrderHistory() async {
    try {
      final res = await _client.getJson(ApiPath.orders);
      // API spec shows this is paginated with a 'results' key
      final data = res.data['results'] as List? ?? [];
      return data
          .map((e) => OrderList.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  // --- NEW METHOD ---
  /// GET /api/v1/orders/{id}/
  /// Fetches the full details for a single order.
  Future<Order> fetchOrderDetails(int id) async {
    try {
      final res = await _client.getJson('${ApiPath.orders}$id/');
      return Order.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}