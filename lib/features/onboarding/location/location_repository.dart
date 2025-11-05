// lib/features/onboarding/location/location_repository.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'models/user_location_model.dart'; // <-- Import the new model

class LocationRepository {
  final DioClient _client;
  LocationRepository(this._client);

  /// GET /api/v1/profile/locations/ (NEW)
  Future<List<UserLocation>> fetchUserLocations() async {
    try {
      final res = await _client.getJson(ApiPath.profileLocations);
      // Handle paginated response
      final data = (res.data['results'] as List? ?? []);
      return data
          .map((e) => UserLocation.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw (e.error is ApiFailure)
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e);
    }
  }

  /// POST /api/v1/profile/locations/ (Existing)
  Future<void> saveUserLocation({
    required String label,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _client.dio.post(
        ApiPath.profileLocations,
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