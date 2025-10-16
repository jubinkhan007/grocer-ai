import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../models/referral_model.dart';

class ReferralService {
  final DioClient _dioClient;

  ReferralService(this._dioClient);

  /// GET /api/v1/profile/referrals/
  Future<List<Referral>> fetchReferrals() async {
    try {
      final response = await _dioClient.getJson(ApiPath.profileReferrals);
      final data = response.data;
      if (data is List) {
        return data.map((e) => Referral.fromJson(e)).toList();
      } else if (data is Map && data['results'] != null) {
        return (data['results'] as List)
            .map((e) => Referral.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('GET /referrals failed: ${e.message}');
      rethrow;
    }
  }

  /// POST create referral
  Future<Referral?> addReferral(Map<String, dynamic> payload) async {
    try {
      final response =
      await _dioClient.postJson(ApiPath.profileReferrals, payload);
      return Referral.fromJson(response.data);
    } on DioException catch (e) {
      print('POST /referrals failed: ${e.message}');
      rethrow;
    }
  }

  /// PATCH or PUT update
  Future<Referral?> updateReferral(
      int id,
      Map<String, dynamic> data, {
        bool partial = true,
      }) async {
    try {
      final method = partial ? _dioClient.patchJson : _dioClient.putJson;
      final response = await method('${ApiPath.profileReferrals}$id/', data);
      return Referral.fromJson(response.data);
    } on DioException catch (e) {
      print('UPDATE /referrals/$id failed: ${e.message}');
      rethrow;
    }
  }

  /// DELETE referral
  Future<void> deleteReferral(int id) async {
    try {
      await _dioClient.deleteJson('${ApiPath.profileReferrals}$id/');
    } on DioException catch (e) {
      print('DELETE /referrals/$id failed: ${e.message}');
      rethrow;
    }
  }
}
