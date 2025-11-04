// lib/features/orders/models/order_preference_model.dart
import 'dart:convert';

// --- Used to GET /api/v1/order-preference-list/ ---

class OrderPreferenceListResponse {
  final int count;
  final List<OrderPreferenceItem> results;

  OrderPreferenceListResponse({required this.count, required this.results});

  factory OrderPreferenceListResponse.fromJson(Map<String, dynamic> json) {
    return OrderPreferenceListResponse(
      count: json['count'] ?? 0,
      results: (json['results'] as List? ?? [])
          .map((e) => OrderPreferenceItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderPreferenceItem {
  final int id;
  final String preferenceType;
  final String title;
  final String? helpText;
  final bool isMandatory;
  final List<OrderPreferenceOption> options;
  final int? triggerOption; // The option.id that triggers something
  final bool allowFiles;
  final bool allowChildren;

  OrderPreferenceItem({
    required this.id,
    required this.preferenceType,
    required this.title,
    this.helpText,
    required this.isMandatory,
    required this.options,
    this.triggerOption,
    required this.allowFiles,
    required this.allowChildren,
  });

  factory OrderPreferenceItem.fromJson(Map<String, dynamic> json) {
    return OrderPreferenceItem(
      id: json['id'] ?? 0,
      preferenceType: json['preference_type'] ?? 'text',
      title: json['title'] ?? '',
      helpText: json['help_text'],
      isMandatory: json['is_mandatory'] ?? false,
      options: (json['options'] as List? ?? [])
          .map((e) => OrderPreferenceOption.fromJson(e))
          .toList(),
      triggerOption: json['trigger_option'],
      allowFiles: json['allow_files'] ?? false,
      allowChildren: json['allow_children'] ?? false,
    );
  }
}

class OrderPreferenceOption {
  final int id;
  final String label;
  final String? icon;

  OrderPreferenceOption({required this.id, required this.label, this.icon});

  factory OrderPreferenceOption.fromJson(Map<String, dynamic> json) {
    return OrderPreferenceOption(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      icon: json['icon'],
    );
  }
}

// --- Used to GET /api/v1/order-preferences/ ---
// (Based on image_acb561.png)
class PaginatedOrderPreferenceList {
  final int count;
  final List<SavedOrderPreference> results;

  PaginatedOrderPreferenceList({required this.count, required this.results});

  factory PaginatedOrderPreferenceList.fromJson(Map<String, dynamic> json) {
    return PaginatedOrderPreferenceList(
      count: json['count'] ?? 0,
      results: (json['results'] as List? ?? [])
          .map((e) => SavedOrderPreference.fromJson(e))
          .toList(),
    );
  }
}

class SavedOrderPreference {
  final int id;
  final int preference; // ID of the question
  final int? selectedOption; // ID of the answer
  final List<int> selectedOptions;
  final String? additionInfo;
  final String? numberValue;
  final List<PreferenceFile> files; // Assuming files are just IDs or URLs

  SavedOrderPreference({
    required this.id,
    required this.preference,
    this.selectedOption,
    required this.selectedOptions,
    this.additionInfo,
    this.numberValue,
    required this.files,
  });

  factory SavedOrderPreference.fromJson(Map<String, dynamic> json) {
    return SavedOrderPreference(
      id: json['id'] ?? 0,
      preference: json['preference'] ?? 0,
      selectedOption: json['selected_option'],
      selectedOptions: (json['selected_options'] as List? ?? [])
          .map((e) => e as int)
          .toList(),
      additionInfo: json['addition_info'],
      numberValue: json['number_value'],
      files: (json['files'] as List? ?? [])
          .map((e) => PreferenceFile.fromJson(e as Map<String, dynamic>))
          .toList(),

    );
  }
}

// --- Used to POST /api/v1/order-preferences/ ---
// (Based on image_acb8a1.png)
class OrderPreferenceRequest {
  final int preference;
  final int? selectedOption;
  final List<int>? selectedOptions;
  final String? additionInfo;
  final List<int>? fileIds; // Assuming we send file IDs

  OrderPreferenceRequest({
    required this.preference,
    this.selectedOption,
    this.selectedOptions,
    this.additionInfo,
    this.fileIds,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'preference': preference,
    };
    if (selectedOption != null) {
      data['selected_option'] = selectedOption;
    }
    if (selectedOptions != null) {
      data['selected_options'] = selectedOptions;
    }
    if (additionInfo != null) {
      data['addition_info'] = additionInfo;
    }
    if (fileIds != null) {
      data['file_ids'] = fileIds;
    }
    return data;
  }
}


class PreferenceFile {
  final int id;
  final String url;
  const PreferenceFile({required this.id, required this.url});

  factory PreferenceFile.fromJson(Map<String, dynamic> j) =>
      PreferenceFile(id: j['id'] ?? 0, url: (j['file'] ?? '').toString());
}