// dio_pretty.dart
import 'dart:convert';
import 'package:dio/dio.dart';

class DioPretty {
  static String message(Object err) {
    if (err is DioException) {
      final r = err.response;
      final code = r?.statusCode;
      final method = err.requestOptions.method;
      final url = err.requestOptions.uri.toString();

      String body;
      final data = r?.data;
      if (data == null) {
        body = 'null';
      } else if (data is String) {
        body = data;
      } else {
        try { body = jsonEncode(data); } catch (_) { body = data.toString(); }
      }

      return 'HTTP $code • ${err.type.name}\n$method $url\n$body';
    }
    return err.toString();
  }
}
