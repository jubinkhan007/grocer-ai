// lib/features/profile/views/dashboard_preference_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../controllers/dashboard_preference_controller.dart';

// --- MODIFIED: Converted to GetView<DashboardPreferenceController> ---
class DashboardPreferenceSheet extends GetView<DashboardPreferenceController> {
  const DashboardPreferenceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // --- No need to Get.find(), 'controller' is now available ---

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        // --- MODIFIED: Wrapped in Obx to be reactive ---
        return Obx(() {
          if (controller.isLoading.value) {
            // --- Use a container that respects the sheet's shape ---
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final prefs = controller.prefs.value;
          // --- Handle null state ---
          if (prefs == null) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: const Center(child: Text("Could not load preferences.")),
            );
          }

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

                // --- MODIFIED: Tiles are now dynamic ---
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
        color: AppColors.bg, // Use AppColors.bg for consistency
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