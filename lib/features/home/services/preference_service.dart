// lib/features/home/services/preference_service.dart
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/home/models/preference_completeness_model.dart';

class PreferenceService {
  final DioClient _client;
  PreferenceService(this._client);

  Future<PreferenceCompleteness> fetchCompleteness() async {
    final res = await _client.getJson(ApiPath.preferenceCompleteness);
    return PreferenceCompleteness.fromJson(res.data as Map<String, dynamic>);
  }
}
