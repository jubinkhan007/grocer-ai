import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../models/partner_model.dart';

class PartnerService {
  final DioClient _dioClient;

  PartnerService(this._dioClient);

  /// GET partners list
  Future<List<Partner>> fetchPartners() async {
    try {
      final response = await _dioClient.getJson(ApiPath.profilePartners);
      final data = response.data;
      if (data is List) {
        return data.map((e) => Partner.fromJson(e)).toList();
      } else if (data is Map && data['results'] != null) {
        return (data['results'] as List)
            .map((e) => Partner.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('GET /partners failed: ${e.message}');
      rethrow;
    }
  }

  /// POST add partner
  Future<Partner?> addPartner(String name) async {
    try {
      final response = await _dioClient.postJson(
        ApiPath.profilePartners,
        {'name': name},
      );
      return Partner.fromJson(response.data);
    } on DioException catch (e) {
      print('POST /partners failed: ${e.message}');
      rethrow;
    }
  }

  /// PATCH/PUT update partner
  Future<Partner?> updatePartner(int id, Map<String, dynamic> data,
      {bool partial = true}) async {
    try {
      final method = partial
          ? _dioClient.patchJson
          : _dioClient.putJson; // same as in your ProfileService
      final response =
      await method('${ApiPath.profilePartners}$id/', data);
      return Partner.fromJson(response.data);
    } on DioException catch (e) {
      print('UPDATE /partners/$id failed: ${e.message}');
      rethrow;
    }
  }

  /// DELETE partner
  Future<void> deletePartner(int id) async {
    try {
      await _dioClient.deleteJson('${ApiPath.profilePartners}$id/');
    } on DioException catch (e) {
      print('DELETE /partners/$id failed: ${e.message}');
      rethrow;
    }
  }
}
