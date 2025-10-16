import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import '../models/notification_model.dart';

class NotificationService {
  final DioClient _client;
  NotificationService(this._client);

  Future<List<AppNotification>> fetchNotifications() async {
    final res = await _client.getJson(ApiPath.notifications);
    final data = res.data;

    if (data['results'] is List) {
      return (data['results'] as List)
          .map((e) => AppNotification.fromJson(e))
          .toList();
    }
    return [];
  }
}
