import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CurrentUserService {
  final GetStorage _box;

  CurrentUserService(this._box);

  Map<String, dynamic>? get _claims {
    final token = _box.read<String>('access_token');
    if (token == null || token.isEmpty) return null;

    try {
      return JwtDecoder.decode(token);
    } catch (_) {
      return null;
    }
  }

  int? get userId {
    final v = _claims?['user_id'];
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  String? get name => _claims?['name'] as String?;
  String? get email => _claims?['email'] as String?;
  String? get referralCode => _claims?['referral_code'] as String?;
}
