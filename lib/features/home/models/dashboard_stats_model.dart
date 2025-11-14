// lib/features/home/models/dashboard_stats_model.dart
import 'dart:ui';


class LastMonthStats {
  final String month;
  final num totalSpent;
  final num totalSaved;
  final num? spentChangePercentage;

  LastMonthStats({
    required this.month,
    required this.totalSpent,
    required this.totalSaved,
    this.spentChangePercentage,
  });

  factory LastMonthStats.fromJson(Map<String, dynamic> json) {
    return LastMonthStats(
      month: json['month'] ?? 'N/A',
      totalSpent: json['total_spent'] ?? 0,
      totalSaved: json['total_saved'] ?? 0,
      spentChangePercentage: json['spent_change_percentage'],
    );
  }
}

class AnalysisStats {
  final num fruits;
  final num vegetables;
  final num dairy;
  final num grains;

  AnalysisStats({
    required this.fruits,
    required this.vegetables,
    required this.dairy,
    required this.grains,
  });

  factory AnalysisStats.fromJson(Map<String, dynamic> json) {
    return AnalysisStats(
      fruits: json['fruits'] ?? 0,
      vegetables: json['vegetables'] ?? 0,
      dairy: json['dairy'] ?? 0,
      grains: json['grains'] ?? 0,
    );
  }

  // Helper to match the UI's static data structure
  List<LegendData> get asLegendData {
    return [
      LegendData(
        color: const Color(0xFF295457),
        label: 'Fruits',
        value: fruits.toDouble(),
      ),
      LegendData(
        color: const Color(0xFFBA4012),
        label: 'Vegetables',
        value: vegetables.toDouble(),
      ),
      LegendData(
        color: const Color(0xFFC2EF8F),
        label: 'Dairy',
        value: dairy.toDouble(),
      ),
      LegendData(
        color: const Color(0xFFBABABA),
        label: 'Grains',
        value: grains.toDouble(),
      ),
    ];
  }
}

class LegendData {
  final Color color;
  final String label;
  final double value;
  LegendData({required this.color, required this.label, required this.value});
}