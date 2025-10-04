// lib/features/preferences/views/prefs_cuisine_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/preferences/views/prefs_diet_view.dart';
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
            Expanded(
              child: Obx(() {
                final list = c.options.value?.cuisine ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuisine preference',
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF33363E),
                            ),
                      ),
                      const SizedBox(height: 16),
                      ...list.map(
                        (d) => _checkTile(
                          title: d,
                          selected: c.cuisineSelected.contains(d),
                          onChanged: (v) {
                            if (v)
                              c.cuisineSelected.add(d);
                            else
                              c.cuisineSelected.remove(d);
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
            PrimaryBarButton(
              onTap: () => Get.toNamed(Routes.prefsFreq),
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
