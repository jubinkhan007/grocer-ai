// lib/features/preferences/preferences_repository.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';

class PreferencesRepository {
  final DioClient _client;
  PreferencesRepository(this._client);

  /// GET /api/v1/preferences/ (paginated)
  Future<List<PreferenceItem>> fetchAll() async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        ApiPath.preferences,
      );
      final data = (res.data ?? const {}) as Map<String, dynamic>;
      final list = (data['results'] as List? ?? const []);
      return list
          .map((e) => PreferenceItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw (e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e));
    }
  }

  /// POST /api/v1/user-preferences/
  Future<void> postUserPreference(UserPrefPayload payload) async {
    try {
      await _client.dio.post(ApiPath.userPreferences, data: payload.toJson());
    } on DioException catch (e) {
      throw (e.error is ApiFailure
          ? e.error as ApiFailure
          : ApiFailure.fromDioError(e));
    }
  }
}

/// ----------------- Models (loosely typed to survive schema tweaks) -----------------
class PreferenceItem {
  final int id;
  final String type; // single | multiple | number | num_rng
  final String title; // “Nearby Grocers”...
  final String? helpText;
  final String listType; // “hor” | “ver”
  final bool isMandatory;
  final List<PrefOption> options;

  PreferenceItem({
    required this.id,
    required this.type,
    required this.title,
    required this.helpText,
    required this.listType,
    required this.isMandatory,
    required this.options,
  });

  factory PreferenceItem.fromJson(Map<String, dynamic> j) => PreferenceItem(
    id: (j['id'] ?? 0) as int,
    type: (j['preference_type'] ?? '').toString(),
    title: (j['title'] ?? '').toString(),
    helpText: j['help_text']?.toString(),
    listType: (j['option_list_type'] ?? '').toString(),
    isMandatory: (j['is_mandatory'] ?? false) as bool,
    options: ((j['options'] ?? []) as List)
        .map((e) => PrefOption.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class PrefOption {
  final int id;
  final String? label;
  final String? icon;
  final int? numberValue; // for number screens
  final String? rangeText; // for num_rng screens

  PrefOption({
    required this.id,
    this.label,
    this.icon,
    this.numberValue,
    this.rangeText,
  });

  factory PrefOption.fromJson(Map<String, dynamic> j) => PrefOption(
    id: (j['id'] ?? 0) as int,
    label: j['label']?.toString(),
    icon: j['icon']?.toString(),
    numberValue: j['number_value'] is int ? j['number_value'] as int : null,
    rangeText: j['range_text']?.toString(),
  );
}

class UserPrefPayload {
  final int preference; // preference id
  final int? selectedOption; // for single choice
  final List<int>? selectedOptions; // for multiple choice
  final String? additionInfo; // notes
  final String? numberValue; // numeric value as string when applicable

  UserPrefPayload({
    required this.preference,
    this.selectedOption,
    this.selectedOptions,
    this.additionInfo,
    this.numberValue,
  });

  Map<String, dynamic> toJson() => {
    'preference': preference,
    if (selectedOption != null) 'selected_option': selectedOption,
    if (selectedOptions != null) 'selected_options': selectedOptions,
    if (additionInfo != null) 'addition_info': additionInfo,
    if (numberValue != null) 'number_value': numberValue,
  };
}
