// lib/features/orders/services/order_preference_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/orders/models/order_preference_model.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' as http;

import '../models/generated_order_model.dart';

class OrderPreferenceService {
  final DioClient _client;
  OrderPreferenceService(this._client);

  Future<List<OrderPreferenceItem>> fetchOrderPreferences() async {
    final response = await _client.getJson(ApiPath.orderPreferenceList);
    return OrderPreferenceListResponse.fromJson(response.data).results;
  }

  Future<List<SavedOrderPreference>> fetchSavedPreferences() async {
    final response = await _client.getJson(ApiPath.orderPreferences);
    return PaginatedOrderPreferenceList.fromJson(response.data).results;
  }

  Future<void> saveOrderPreference(OrderPreferenceRequest payload) async {
    await _client.postJson(ApiPath.orderPreferences, payload.toJson());
  }

  // 👇 NEW: one-shot multipart with files + other fields
  Future<void> saveOrderPreferenceWithFiles({
    required int preferenceId,
    int? selectedOptionId,
    String? additionInfo,
    required List<PlatformFile> pickedFiles,
  }) async {
    final files = <MultipartFile>[];
    for (final f in pickedFiles) {
      final ct = _contentTypeFor(f.path ?? f.name); // 👈 http.MediaType?

      if (f.path != null) {
        files.add(await MultipartFile.fromFile(
          f.path!,
          filename: f.name,
          contentType: ct, // 👈 now correct type
        ));
      } else if (f.bytes != null) {
        files.add(MultipartFile.fromBytes(
          f.bytes!,
          filename: f.name,
          contentType: ct, // 👈 now correct type
        ));
      }
    }

    final form = FormData.fromMap({
      'preference': preferenceId,
      if (selectedOptionId != null) 'selected_option': selectedOptionId,
      if (additionInfo != null && additionInfo.isNotEmpty) 'addition_info': additionInfo,
      'files': files,
    });

    await _client.postMultipart(ApiPath.orderPreferences, form);


  }

  // 👇 Return http_parser's MediaType (Dio accepts this)
  http.MediaType? _contentTypeFor(String pathOrName) {
    final m = lookupMimeType(pathOrName);
    if (m == null) return null;
    return http.MediaType.parse(m); // e.g. "image/jpeg"
  }

  Future<void> saveWithFileIds({
    required int preferenceId,
    int? selectedOptionId,
    String? additionInfo,
    required List<int> fileIds,
  }) async {
    final payload = OrderPreferenceRequest(
      preference: preferenceId,
      selectedOption: selectedOptionId,
      additionInfo: additionInfo,
      fileIds: fileIds,
    );
    await _client.postJson(ApiPath.orderPreferences, payload.toJson());
  }

  // If backend **only** returns URLs and supports `file_urls` (add this field server-side):
  Future<void> saveWithFileUrls({
    required int preferenceId,
    int? selectedOptionId,
    String? additionInfo,
    required List<String> urls,
  }) async {
    final body = {
      'preference': preferenceId,
      if (selectedOptionId != null) 'selected_option': selectedOptionId,
      if (additionInfo != null && additionInfo.isNotEmpty) 'addition_info': additionInfo,
      'file_urls': urls, // <-- Add write-only `file_urls` on the serializer
    };
    await _client.postJson(ApiPath.orderPreferences, body);
  }

  /// POST /api/v1/order-preferences/ (Mode 3: JSON, returns Order List)
  /// Triggers the AI order generation by sending the final preference.
  /// --- MODIFIED: Added optional providerId ---
  Future<GeneratedOrderResponse> generateOrderList({
    required int preferenceId,
    String? additionInfo,
    int? providerId, // Optional: to generate for a specific provider
  }) async {
    final payload = {
      'preference': preferenceId,
      'addition_info': additionInfo ?? '',
      if (providerId != null) 'provider': providerId, // Add provider if included
    };

    final response = await _client.postJson(ApiPath.orderPreferences, payload);
    return GeneratedOrderResponse.fromJson(response.data);
  }
}

// Tiny MediaType shim if you don't already have http_parser:
class MediaType {
  final String type;
  final String subtype;
  const MediaType(this.type, this.subtype);
  @override
  String toString() => '$type/$subtype';
}
