import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../controllers/dashboard_preference_controller.dart';

class DashboardPreferenceSheet extends StatelessWidget {
  const DashboardPreferenceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardPreferenceController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final prefs = controller.prefs.value;
          if (prefs == null) return const SizedBox();

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dashboard Preference',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text('Skip',
                          style: TextStyle(
                              color: AppColors.teal,
                              fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
                const SizedBox(height: 24),

                _prefTile(
                  'Last order',
                  prefs.showLastOrder,
                      (v) => controller.togglePref('show_last_order', v),
                ),
                const SizedBox(height: 12),
                _prefTile(
                  'Monthly statement',
                  prefs.showMonthlyStatement,
                      (v) => controller.togglePref('show_monthly_statement', v),
                ),
                const SizedBox(height: 12),
                _prefTile(
                  'Analysis',
                  prefs.showAnalysis,
                      (v) => controller.togglePref('show_analysis', v),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _prefTile(String label, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.teal,
          ),
        ],
      ),
    );
  }
}
