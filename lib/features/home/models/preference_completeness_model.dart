// lib/features/home/models/preference_completeness_model.dart
class PreferenceCompleteness {
  final double overallPercentage;
  final double mandatoryPercentage;

  PreferenceCompleteness({
    required this.overallPercentage,
    required this.mandatoryPercentage,
  });

  factory PreferenceCompleteness.fromJson(Map<String, dynamic> json) {
    return PreferenceCompleteness(
      overallPercentage:
      (json['overall_percentage'] as num?)?.toDouble() ?? 0.0,
      mandatoryPercentage:
      (json['mandatory_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
