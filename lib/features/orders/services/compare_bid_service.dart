// New File
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/orders/models/compare_bid_model.dart';

class CompareBidService {
  final DioClient _client;
  CompareBidService(this._client);

  /// Fetches the initial list of bids
  /// GET /api/v1/compare-grocery/
  Future<List<CompareBid>> fetchBids() async {
    try {
      final response = await _client.getJson(ApiPath.compareGrocery);
      final List<dynamic> data = response.data as List;
      return data.map((json) => CompareBid.fromJson(json)).toList();
    } on DioException catch (e) {
      throw (e.error is ApiFailure)
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    } catch (e) {
      throw ApiFailure(message: 'Failed to parse comparison data: $e');
    }
  }

  /// Fetches an updated list of bids
  /// GET /api/v1/bid-grocery/
  Future<List<CompareBid>> rebid() async {
    try {
      final response = await _client.getJson(ApiPath.bidGrocery);
      final List<dynamic> data = response.data as List;
      return data.map((json) => CompareBid.fromJson(json)).toList();
    } on DioException catch (e) {
      throw (e.error is ApiFailure)
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    } catch (e) {
      throw ApiFailure(message: 'Failed to parse rebid data: $e');
    }
  }
}
