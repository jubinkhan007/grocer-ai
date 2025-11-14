// lib/features/home/services/dashboard_service.dart
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/home/models/banner_model.dart';
import 'package:grocer_ai/features/home/models/dashboard_stats_model.dart';

class DashboardService {
  final DioClient _client;
  DashboardService(this._client);

  Future<List<BannerModel>> fetchBanners() async {
    final res = await _client.getJson(ApiPath.banners);
    return PaginatedBannerList.fromJson(res.data).results;
  }

  Future<LastMonthStats> fetchLastMonthStats() async {
    final res = await _client.getJson(ApiPath.lastMonthStats);
    return LastMonthStats.fromJson(res.data);
  }

  Future<AnalysisStats> fetchAnalysisStats() async {
    final res = await _client.getJson(ApiPath.analysisStats);
    return AnalysisStats.fromJson(res.data);
  }
}