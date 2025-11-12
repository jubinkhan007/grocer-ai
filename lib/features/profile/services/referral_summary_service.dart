// lib/features/profile/services/referral_summary_service.dart
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/profile/models/faq_model.dart';
import 'package:grocer_ai/features/profile/models/flow_step_model.dart';

class ReferralSummaryService {
  final DioClient _client;
  ReferralSummaryService(this._client);

  /// GET /api/v1/faqs/
  Future<List<Faq>> fetchFaqs() async {
    final res = await _client.getJson(ApiPath.faqs);
    final data = res.data['results'] as List? ?? [];
    return data.map((e) => Faq.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET /api/v1/flow-steps/?type=faq
  Future<List<FlowStep>> fetchFlowSteps() async {
    final res = await _client.getJson(
      ApiPath.flowSteps,
      query: {'type': 'faq'},
    );
    final data = res.data['results'] as List? ?? [];
    return data.map((e) => FlowStep.fromJson(e as Map<String, dynamic>)).toList();
  }
}