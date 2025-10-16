class DashboardPreference {
  bool showLastOrder;
  bool showMonthlyStatement;
  bool showAnalysis;

  DashboardPreference({
    required this.showLastOrder,
    required this.showMonthlyStatement,
    required this.showAnalysis,
  });

  factory DashboardPreference.fromJson(Map<String, dynamic> json) {
    return DashboardPreference(
      showLastOrder: json['show_last_order'] ?? false,
      showMonthlyStatement: json['show_monthly_statement'] ?? false,
      showAnalysis: json['show_analysis'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'show_last_order': showLastOrder,
    'show_monthly_statement': showMonthlyStatement,
    'show_analysis': showAnalysis,
  };
}
