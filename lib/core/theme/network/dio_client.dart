import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'api_endpoints.dart';
import 'error_mapper.dart';

class DioClient {
  final Dio dio;
  final GetStorage _box = GetStorage();

  DioClient._internal(this.dio);

  factory DioClient() {
    final options = BaseOptions(
      baseUrl: ApiEnv.base,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {
        'accept': 'application/json',
        // If your backend requires CSRF on login, set it here:
        // 'X-CSRFToken': '<token>',
      },
    );

    final dio = Dio(options);

    // ---- Interceptors ----
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // attach bearer if present
          final token = GetStorage().read('auth_token');
          if (token != null && token.toString().isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) {
          // Centralized mapping (network → ApiFailure)
          final mapped = ApiFailure.fromDioError(e);
          handler.reject(mapped.asDioError());
        },
      ),
    );

    // Pretty logging (debug only)
    assert(() {
      // ignore: avoid_print
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
      return true;
    }());

    return DioClient._internal(dio);
  }

  // convenience HTTP helpers (typed)
  Future<Response<T>> postJson<T>(String path, Map<String, dynamic> body) {
    return dio.post<T>(path, data: body);
  }
}
