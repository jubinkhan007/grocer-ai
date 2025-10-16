import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import '../models/dashboard_preference_model.dart';

class DashboardPreferenceService {
  final DioClient _client;
  DashboardPreferenceService(this._client);

  Future<DashboardPreference?> fetchPreferences() async {
    final res = await _client.getJson(ApiPath.dashboardPreferences);
    return DashboardPreference.fromJson(res.data);
  }

  Future<DashboardPreference?> updatePreferences(Map<String, dynamic> data) async {
    final res = await _client.patchJson(ApiPath.dashboardPreferences, data);
    return DashboardPreference.fromJson(res.data);
  }
}
