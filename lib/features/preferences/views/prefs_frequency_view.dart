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
    final c = controller;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderArc(),

            // ---------------- Main content ----------------
            Expanded(
              child: Obx(() {
                if (c.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pref = c.frequency;
                if (pref == null) {
                  return const Center(
                    child: Text('Unable to load frequency preferences.'),
                  );
                }

                final selectedId = c.selectedFrequencyId.value;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pref.title,
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF33363E),
                            ),
                      ),
                      const SizedBox(height: 16),

                      // 🟢 List of options from API
                      ...pref.options.map(
                        (o) => _radioTile(
                          title: o.label ?? '',
                          selected: selectedId == o.id,
                          onTap: () {
                            c.selectedFrequencyId.value = o.id;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            // ---------------- Bottom button ----------------
            Obx(
              () => PrimaryBarButton(
                onTap: () async {
                  await c.submitFrequency();
                  Get.toNamed(Routes.prefsBudget);
                },
                loading: c.loading.value,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 26,
                ),
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
