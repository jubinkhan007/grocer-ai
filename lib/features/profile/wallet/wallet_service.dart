// lib/features/profile/wallet/wallet_service.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/profile/models/wallet_model.dart';

class WalletService {
  final DioClient _client;
  WalletService(this._client);

  /// GET /api/v1/profile/wallet/
  Future<Wallet> fetchWallet() async {
    try {
      final res = await _client.getJson(ApiPath.profileWallet);
      return Wallet.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}