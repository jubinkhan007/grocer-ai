// lib/core/auth/current_user_service.dart

import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CurrentUserService {
  final GetStorage _box;

  CurrentUserService(this._box);

   String? get _effectiveAccessToken {
       // Prefer the key actually used by AuthRepository, but keep fallback
       return _box.read<String>('auth_token') ?? _box.read<String>('access_token');
     }

  Map<String, dynamic>? get _claims {
    final token = _effectiveAccessToken;
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
   // Support either `referral_code` or a future/alt key just in case
   String? get referralCode =>
           (_claims?['referral_code'] ?? _claims?['refCode'] ?? _claims?['ref']) as String?;
}
