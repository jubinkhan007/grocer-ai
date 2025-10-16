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
      },
    );

    final dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = GetStorage().read('auth_token');
          if (token != null && token.toString().isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) {
          final mapped = ApiFailure.fromDioError(e);
          handler.reject(mapped.asDioError());
        },
      ),
    );

    assert(() {
      dio.interceptors.add(
        LogInterceptor(request: true, requestBody: true, responseBody: true),
      );
      return true;
    }());

    return DioClient._internal(dio);
  }

  // ---------- Existing method ----------
  Future<Response<T>> postJson<T>(String path, Map<String, dynamic> body) {
    return dio.post<T>(path, data: body);
  }

  // ---------- NEW helpers ----------
  Future<Response<T>> getJson<T>(String path, {Map<String, dynamic>? query}) {
    return dio.get<T>(path, queryParameters: query);
  }

  Future<Response<T>> putJson<T>(String path, Map<String, dynamic> body) {
    return dio.put<T>(path, data: body);
  }

  Future<Response<T>> patchJson<T>(String path, Map<String, dynamic> body) {
    return dio.patch<T>(path, data: body);
  }

  Future<Response<T>> deleteJson<T>(String path, {Map<String, dynamic>? query}) {
    return dio.delete<T>(path, queryParameters: query);
  }
}

