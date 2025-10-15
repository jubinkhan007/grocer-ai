// lib/features/location/location_repository.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';

class LocationRepository {
  final DioClient _client;
  LocationRepository(this._client);

  Future<void> saveUserLocation({
    required String label,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _client.dio.post(
        '/api/v1/profile/locations/',
        data: {
          'label': label,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
        },
      );
    } on DioException catch (e) {
      throw (e.error is ApiFailure)
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }
}
