// lib/features/profile/transactions/transaction_service.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';

import 'model/transaction_model.dart';


class TransactionService {
  final DioClient _client;
  TransactionService(this._client);

  /// GET /api/v1/profile/transactions/ (Paginated)
  Future<List<ProfilePaymentTransaction>> fetchTransactions() async {
    try {
      final res = await _client.getJson(ApiPath.profileTransactions);
      // API spec shows this is paginated with a 'results' key
      final data = res.data['results'] as List? ?? [];
      return data
          .map((e) =>
          ProfilePaymentTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// GET /api/v1/profile/transactions/{id}/
  /// Note: This endpoint returns a single transaction, not the order list.
  Future<ProfilePaymentTransaction> fetchTransactionDetails(String id) async {
    try {
      final res = await _client.getJson('${ApiPath.profileTransactions}$id/');
      return ProfilePaymentTransaction.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}