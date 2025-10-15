import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../preferences_controller.dart';
import '../widgets/prefs_widgets.dart';
import '../../../app/app_routes.dart';

const _teal = Color(0xFF0C3E3D);
const _bg = Color(0xFFF1F4F6);

class PrefsCuisineView extends GetView<PreferencesController> {
  const PrefsCuisineView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderArc(),

            // -------------------- Main Content --------------------
            Expanded(
              child: Obx(() {
                if (c.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pref = c.cuisine;
                if (pref == null) {
                  return const Center(
                    child: Text('Unable to load cuisine preferences.'),
                  );
                }

                final selected = c.selectedCuisineIds;

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
                      if (pref.helpText != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          pref.helpText!,
                          style: const TextStyle(
                            color: Color(0xFF6B737C),
                            fontSize: 16,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // 🟢 Render API options as checkboxes
                      ...pref.options.map(
                        (opt) => _checkTile(
                          title: opt.label ?? '',
                          selected: selected.contains(opt.id),
                          onChanged: (v) {
                            if (v) {
                              selected.add(opt.id);
                            } else {
                              selected.remove(opt.id);
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 18),
                      const Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      NoteField(
                        hint: 'Enter your cuisine preference',
                        onChanged: (v) => c.cuisineNote.value = v,
                      ),
                    ],
                  ),
                );
              }),
            ),

            // -------------------- Bottom Next Button --------------------
            Obx(
              () => PrimaryBarButton(
                onTap: () async {
                  await c.submitCuisine();
                  Get.toNamed(Routes.prefsFreq);
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

  static Widget _checkTile({
    required String title,
    required bool selected,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: (v) => onChanged(v ?? false),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        activeColor: _teal,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
