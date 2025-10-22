// lib/features/products/data/products_repository.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import '../models/product.dart';

class ProductsRepository {
  final DioClient _client;
  ProductsRepository(this._client);

  /// GET /api/v1/products/?search=<query>
  Future<List<Product>> fetch({String? search}) async {
    try {
      // Ask Dio for dynamic so we can handle both list and map payloads
      final res = await _client.dio.get<dynamic>(
        ApiPath.products,
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final payload = res.data;

      // Normalize into a List<dynamic>
      List<dynamic> raw;
      if (payload is List) {
        raw = payload;
      } else if (payload is Map<String, dynamic>) {
        if (payload['results'] is List) {
          raw = payload['results'] as List;
        } else if (payload['data'] is List) {
          // optional fallback if backend wraps in `data`
          raw = payload['data'] as List;
        } else {
          raw = const [];
        }
      } else {
        raw = const [];
      }

      return raw
          .map((e) => Product.fromJson(
        (e as Map).cast<String, dynamic>(),
      ))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}
