// lib/features/preferences/views/prefs_frequency_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../preferences_controller.dart';
import '../widgets/prefs_widgets.dart';
import '../../../app/app_routes.dart';

const _teal = Color(0xFF0C3E3D);
const _bg = Color(0xFFF1F4F6);

class PrefsFrequencyView extends GetView<PreferencesController> {
  const PrefsFrequencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderArc(),
            Expanded(
              child: Obx(() {
                final list = controller.options.value?.frequency ?? [];
                final selected = controller.frequency.value;
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Your Shopping Frequency',
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF33363E),
                            ),
                      ),
                      const SizedBox(height: 16),
                      ...list.map(
                        (f) => _radioTile(
                          title: f,
                          selected: selected == f,
                          onTap: () => controller.frequency.value = f,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            PrimaryBarButton(
              onTap: () => Get.toNamed(Routes.prefsBudget),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _radioTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: _teal,
        ),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: onTap,
      ),
    );
  }
}
