import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../models/personal_info_model.dart';

class ProfileService {
  final DioClient _dioClient;

  ProfileService(this._dioClient);

  /// GET personal info
  Future<PersonalInfo?> fetchPersonalInfo() async {
    try {
      final response = await _dioClient.getJson(ApiPath.profilePersonalInfo);
      return PersonalInfo.fromJson(response.data);
    } on DioException catch (e) {
      print('GET personal-info failed: ${e.message}');
      rethrow;
    }
  }

  /// PUT or PATCH to update personal info
  Future<PersonalInfo?> updatePersonalInfo({
    required Map<String, dynamic> data,
    bool partial = false, // true = PATCH, false = PUT
  }) async {
    try {
      final response = partial
          ? await _dioClient.patchJson(ApiPath.profilePersonalInfo, data)
          : await _dioClient.putJson(ApiPath.profilePersonalInfo, data);
      return PersonalInfo.fromJson(response.data);
    } on DioException catch (e) {
      print('UPDATE personal-info failed: ${e.message}');
      rethrow;
    }
  }
}
