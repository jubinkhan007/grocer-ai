// lib/features/profile/services/partner_service.dart

import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../models/partner_model.dart';
import '../models/partner_search_user.dart';

class PartnerService {
  final DioClient _dio;
  PartnerService(this._dio);

  /// GET /api/v1/profile/partners/
  Future<List<Partner>> fetchPartners() async {
    final res = await _dio.getJson(ApiPath.profilePartners);
    final data = res.data;

    if (data is List) {
      return data.map((e) => Partner.fromJson(e)).toList();
    } else if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => Partner.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET /api/v1/profile/users/?search=<query>
  Future<List<PartnerSearchUser>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];
    final res = await _dio.getJson(
      '${ApiPath.profileUsers}?search=${Uri.encodeQueryComponent(query.trim())}',
    );
    final data = res.data;

    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => PartnerSearchUser.fromJson(e))
          .toList();
    }
    return [];
  }

  /// POST /api/v1/profile/partners/  { "partner_id": <id> }
  Future<Partner?> addPartner({required int partnerId}) async {
    try {
      final res = await _dio.postJson(
        ApiPath.profilePartners,
        {'partner_id': partnerId},
      );
      return Partner.fromJson(res.data);
    } on DioException catch (e) {
      // Surface backend message to caller
      print('addPartner failed: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  /// DELETE /api/v1/profile/partners/<id>/
  Future<void> removePartner(int relationId) async {
    await _dio.deleteJson('${ApiPath.profilePartners}$relationId/');
  }
}
