import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';

class SecurityService {
  final DioClient _client;
  SecurityService(this._client);

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final data = {
      'old_password': oldPassword,
      'password': newPassword,
      'confirm_password': confirmPassword,
    };
    await _client.postJson(ApiPath.passwordChange, data);
  }
}
