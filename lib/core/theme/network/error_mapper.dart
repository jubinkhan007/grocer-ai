import 'dart:convert';
import 'package:dio/dio.dart';

class ApiFailure implements Exception {
  final String message; // primary message (detail/message)
  final String? code; // optional machine code
  final int? status; // http status
  final Map<String, List<String>> fieldErrors; // email/password/... -> errors

  ApiFailure({
    required this.message,
    this.code,
    this.status,
    Map<String, List<String>>? fieldErrors,
  }) : fieldErrors = fieldErrors ?? const {};

  /// Convenience
  String? firstFor(String field) {
    final list = fieldErrors[field];
    return (list != null && list.isNotEmpty) ? list.first : null;
  }

  static ApiFailure fromDioError(DioException e) {
    String msg = 'Something went wrong';
    String? code;
    int? status = e.response?.statusCode;
    final Map<String, List<String>> fields = {};

    dynamic data = e.response?.data;

    // Sometimes backend sends a string body
    if (data is String) {
      try {
        data = json.decode(data);
      } catch (_) {}
    }

    if (data is Map) {
      // Prefer structured detail / message
      if (data['detail'] != null) msg = data['detail'].toString();
      if (data['message'] != null) msg = data['message'].toString();
      if (data['code'] != null) code = data['code'].toString();

      // Collect typical field error shapes e.g. { "email": ["..."], "password": ["..."] }
      for (final entry in data.entries) {
        final k = entry.key.toString();
        final v = entry.value;
        if (v is List) {
          fields[k] = v.map((e) => e.toString()).toList();
        } else if (v is String && (k == 'email' || k == 'password')) {
          fields[k] = [v];
        }
      }

      // If we still have the generic msg but there are field errors, build a readable one
      if ((msg == 'Something went wrong' || msg.trim().isEmpty) &&
          fields.isNotEmpty) {
        msg = fields.entries
            .map((e) => '${e.key}: ${e.value.first}')
            .join('\n');
      }
    }

    // Network layer messages
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      msg = 'Network timeout. Please try again.';
      code = 'network_timeout';
    } else if (e.type == DioExceptionType.connectionError) {
      msg = 'No internet connection.';
      code = 'network_error';
    }

    return ApiFailure(
      message: msg,
      code: code,
      status: status,
      fieldErrors: fields,
    );
  }

  /// For our interceptor which rethrows as DioException
  DioException asDioError() => DioException(
    requestOptions: RequestOptions(path: ''),
    error: this,
    response: eResponseLike(),
    type: DioExceptionType.badResponse,
  );

  Response<dynamic>? eResponseLike() => null;
}
