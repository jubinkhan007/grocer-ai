import 'package:dio/dio.dart';

/// Domain failure used across the app.
class ApiFailure implements Exception {
  final String message; // User-facing copy, e.g. "Email is wrong"
  final String? code; // Machine code: e.g. "email_not_found"
  final int? status; // HTTP status
  final DioException? raw;

  ApiFailure({required this.message, this.code, this.status, this.raw});

  /// Build from DioException, normalize common cases.
  factory ApiFailure.fromDioError(DioException e) {
    // Network / timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return ApiFailure(
        message: 'No internet connection',
        code: 'network_error',
        raw: e,
      );
    }

    final status = e.response?.statusCode;
    final data = e.response?.data;

    // Your Swagger error: { "detail": "...", "code": "..." }
    if (data is Map) {
      final detail =
          (data['detail'] ?? data['message'] ?? 'Something went wrong')
              .toString();
      final code = data['code']?.toString();
      return ApiFailure(message: detail, code: code, status: status, raw: e);
    }

    // Fallback
    return ApiFailure(
      message: e.message ?? 'Unexpected error',
      status: status,
      raw: e,
    );
  }

  /// Convert back to DioException so interceptors chain stays happy.
  DioException asDioError() => DioException(
    requestOptions: raw?.requestOptions ?? RequestOptions(),
    response: raw?.response,
    error: this,
    type: raw?.type ?? DioExceptionType.unknown,
    message: message,
  );
}
