// lib/features/auth/data/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
  );
}

class AuthRepository {
  final DioClient _client;
  final GetStorage _box = GetStorage();

  AuthRepository(this._client);

  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.postJson<Map<String, dynamic>>(ApiPath.login, {
        'email': email,
        'password': password,
      });
      final data = res.data;
      if (data == null) {
        throw ApiFailure(
          message: 'Empty response',
          code: 'empty_body',
          status: res.statusCode,
        );
      }
      final tokens = AuthTokens.fromJson(data);
      _box.write('auth_token', tokens.accessToken);
      _box.write('refresh_token', tokens.refreshToken);
      return tokens;
    } on DioException catch (e) {
      final failure = e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
      throw failure;
    }
  }

  // ---------- Forgot Password ----------
  Future<void> requestPasswordReset(String email) async {
    try {
      await _client.postJson(ApiPath.pwReset, {'email': email});
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// Returns (uid, token) from /otp-verify/
  Future<({String uid, String token})> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final res = await _client.postJson<Map<String, dynamic>>(
        ApiPath.pwOtpVerify,
        {'email': email, 'code': code},
      );
      final data = (res.data ?? {}) as Map<String, dynamic>;
      return (uid: data['uid'].toString(), token: data['token'].toString());
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  Future<void> confirmNewPassword({
    required String uid,
    required String token,
    required String password,
  }) async {
    try {
      await _client.postJson(ApiPath.pwConfirm, {
        'password': password,
        'confirm_password': password,
        'uid': uid,
        'token': token,
      });
    } on DioException catch (e) {
      throw e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}
