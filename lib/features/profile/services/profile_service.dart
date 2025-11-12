// lib/features/profile/services/profile_service.dart

import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../models/personal_info_model.dart';

class ProfileService {
  final Dio _dio;

  // Accept DioClient (as used in AppBindings) and expose its Dio
  ProfileService(DioClient client) : _dio = client.dio;

  static const _endpoint = '/api/v1/profile/personal-info/';

  /// GET /profile/personal-info/
  Future<PersonalInfo?> fetchPersonalInfo() async {
    try {
      final response = await _dio.get(_endpoint);

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return PersonalInfo.fromJson(response.data as Map<String, dynamic>);
      }

      return null;
    } on DioException {
      // Let caller handle null
      return null;
    }
  }

  /// PUT/PATCH /profile/personal-info/
  ///
  /// Returns updated PersonalInfo on success.
  /// Throws Exception with a readable message on validation errors.
  Future<PersonalInfo?> updatePersonalInfo({
    required Map<String, dynamic> data,
    bool partial = false,
  }) async {
    try {
      final response = await _dio.request(
        _endpoint,
        data: data,
        options: Options(method: partial ? 'PATCH' : 'PUT'),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data is Map<String, dynamic>) {
        return PersonalInfo.fromJson(response.data as Map<String, dynamic>);
      }

      if (response.statusCode == 400 && response.data is Map<String, dynamic>) {
        throw _extractValidationError(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to update personal information.');
    } on DioException catch (e) {
      final res = e.response;
      if (res != null &&
          res.statusCode == 400 &&
          res.data is Map<String, dynamic>) {
        throw _extractValidationError(res.data as Map<String, dynamic>);
      }
      rethrow;
    }
  }

  Exception _extractValidationError(Map<String, dynamic> map) {
    if (map['mobile_number'] is List && (map['mobile_number'] as List).isNotEmpty) {
      return Exception((map['mobile_number'] as List).first.toString());
    }
    if (map['detail'] is String) {
      return Exception(map['detail'] as String);
    }
    return Exception('Unable to update personal information.');
  }
}
