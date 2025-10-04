// lib/features/preferences/views/prefs_diet_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../preferences_controller.dart';
import '../widgets/prefs_widgets.dart';
import '../../../app/app_routes.dart';

const _teal = Color(0xFF0C3E3D);
const _bg = Color(0xFFF1F4F6);

class PrefsDietView extends GetView<PreferencesController> {
  const PrefsDietView({super.key});

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
                final diet = controller.options.value?.diet ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dietary preference',
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF33363E),
                            ),
                      ),
                      const SizedBox(height: 16),
                      ...diet.map(
                        (d) => _checkTile(
                          title: d,
                          selected: controller.dietSelected.contains(d),
                          onChanged: (v) {
                            if (v)
                              controller.dietSelected.add(d);
                            else
                              controller.dietSelected.remove(d);
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
                        hint: 'Enter your dietary preference',
                        onChanged: (v) => controller.dietNote.value = v,
                      ),
                    ],
                  ),
                );
              }),
            ),
            PrimaryBarButton(
              onTap: () => Get.toNamed(Routes.prefsCuisine),
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

  static Widget _noteField({
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, right: 12),
          child: Icon(Icons.shopping_basket_outlined, color: Color(0xFF2F6767)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
