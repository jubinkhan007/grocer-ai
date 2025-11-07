// lib/features/profile/static_pages/static_page_service.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'models/static_page_model.dart';

class StaticPageService {
  final DioClient _client;
  StaticPageService(this._client);

  /// GET /api/v1/static-pages/{page_type}/
  Future<StaticPage> fetchPage(String pageType) async {
    try {
      final res =
      await _client.getJson('${ApiPath.staticPages}$pageType/');
      return StaticPage.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}