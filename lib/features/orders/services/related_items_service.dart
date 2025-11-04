// lib/features/orders/services/related_items_service.dart

// lib/features/orders/services/related_items_service.dart

import '../../../core/theme/network/api_endpoints.dart';
import '../../../core/theme/network/dio_client.dart';
import '../models/related_product_model.dart';

class RelatedItemsService {
  RelatedItemsService(this._client);
  final DioClient _client;

  Future<List<RelatedProduct>> fetch({int? productId}) async {
    // Use the endpoint constant here
    final res = await _client.getJson<List<dynamic>>(
      ApiPath.relatedProducts, // <-- using the constant
      query: productId != null ? {'product_id': productId} : null,
    );

    final data = res.data ?? const [];
    return data.map((e) => RelatedProduct.fromJson(e as Map<String, dynamic>)).toList();
  }
}

