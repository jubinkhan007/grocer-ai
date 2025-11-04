import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'api_endpoints.dart';
import 'error_mapper.dart';

class DioClient {
  final Dio dio;
  final GetStorage _box = GetStorage();

  // Gate for parallel refresh attempts
  Completer<void>? _refreshing;

  DioClient._internal(this.dio);

  factory DioClient() {
    final options = BaseOptions(
      baseUrl: ApiEnv.base,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {'accept': 'application/json'},
      // We want to see 401s in onResponse so we can refresh
      validateStatus: (_) => true,
    );

    final dio = Dio(options);
    final client = DioClient._internal(dio);
    client._installInterceptors();
    return client;
  }

  // ---------- Public helpers ----------
  Future<Response<T>> postJson<T>(String path, Map<String, dynamic> body) =>
      dio.post<T>(path, data: body);

  Future<Response<T>> getJson<T>(String path, {Map<String, dynamic>? query}) =>
      dio.get<T>(path, queryParameters: query);

  Future<Response<T>> putJson<T>(String path, Map<String, dynamic> body) =>
      dio.put<T>(path, data: body);

  Future<Response<T>> patchJson<T>(String path, Map<String, dynamic> body) =>
      dio.patch<T>(path, data: body);

  Future<Response<T>> deleteJson<T>(String path, {Map<String, dynamic>? query}) =>
      dio.delete<T>(path, queryParameters: query);

  Future<Response<dynamic>> postMultipart(String path, FormData formData) =>
      dio.post(path, data: formData, options: Options(contentType: 'multipart/form-data'));

  // ---------- Interceptors & refresh ----------
  void _installInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _readAccess();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        // Handle 401 here (since validateStatus lets it come as a Response)
        onResponse: (resp, handler) async {
          // If not 401, continue
          if (resp.statusCode != 401) return handler.next(resp);

          // Don’t try to refresh if we're already calling the refresh endpoint
          final path = resp.requestOptions.path;
          if (path == ApiPath.refresh) {
            return handler.next(resp);
          }

          // SimpleJWT style error check is optional; 401 is enough
          final isJwtExpired = true;

          if (!isJwtExpired) return handler.next(resp);

          try {
            await _refreshAccessToken();          // will gate on _refreshing
            final retried = await _retry(resp.requestOptions);
            return handler.resolve(retried);      // return the retried response
          } catch (_) {
            _logout();
            return handler.next(resp);            // bubble the original 401
          }
        },

        onError: (e, handler) {
          // Map only real HTTP errors (badResponse) to your ApiFailure
          if (e.type == DioExceptionType.badResponse && e.response != null) {
            final mapped = ApiFailure.fromDioError(e);
            return handler.reject(mapped.asDioError());
          }
          // Keep timeouts, socket/ATS, cancellation, etc. as-is
          handler.next(e);
        },
      ),
    );

    assert(() {
      dio.interceptors.add(
        LogInterceptor(request: true, requestBody: true, responseBody: true),
      );
      return true;
    }());
  }

  String? _readAccess() {
    // prefer new key; fallback to legacy `auth_token`
    return (_box.read('access_token') ?? _box.read('auth_token'))?.toString();
  }

  String? _readRefresh() => _box.read('refresh_token')?.toString();

  void _writeAccess(String token) {
    _box.write('access_token', token);
    _box.write('auth_token', token); // keep legacy in sync if other code reads it
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshing != null) return _refreshing!.future; // wait if already in flight
    _refreshing = Completer<void>();
    try {
      final refresh = _readRefresh();
      if (refresh == null || refresh.isEmpty) {
        throw StateError('No refresh token stored');
      }

      final resp = await dio.post(
        ApiPath.refresh, // '/api/v1/auth/refresh/'
        data: {'refresh': refresh},
        options: Options(
          headers: {
            // ensure NO bearer is sent to refresh
            'Authorization': null,
            'accept': 'application/json',
            'content-type': 'application/json',
          },
        ),
      );

      if (resp.statusCode == 200) {
        final newAccess = (resp.data['access'] ?? resp.data['access_token'])?.toString();
        if (newAccess == null || newAccess.isEmpty) {
          throw StateError('Refresh ok but no access token in body');
        }
        _writeAccess(newAccess);
        _refreshing!.complete();
      } else {
        throw StateError('Refresh failed: ${resp.statusCode}');
      }
    } catch (e) {
      _refreshing!.completeError(e);
      rethrow;
    } finally {
      _refreshing = null;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions ro) {
    final opts = Options(
      method: ro.method,
      headers: {
        ...?ro.headers,
        'Authorization': 'Bearer ${_readAccess() ?? ''}',
      },
      contentType: ro.contentType,
      responseType: ro.responseType,
    );

    return dio.request<dynamic>(
      ro.path,
      data: ro.data,
      queryParameters: ro.queryParameters,
      options: opts,
    );
  }

  void _logout() {
    _box.remove('access_token');
    _box.remove('auth_token');
    _box.remove('refresh_token');
  }
}
