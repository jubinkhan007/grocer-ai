import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../preferences_controller.dart';
import '../widgets/prefs_widgets.dart';
import '../../../app/app_routes.dart';

const _teal = Color(0xFF0C3E3D);
const _bg = Color(0xFFF1F4F6);
const _chipBg = Color(0xFFEDEDED);

class PrefsBudgetView extends GetView<PreferencesController> {
  const PrefsBudgetView({super.key});

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
                if (c.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pref = c.budget; // dynamic preference from API
                if (pref == null) {
                  return const Center(
                    child: Text('Unable to load budget preferences.'),
                  );
                }

                final budgets = pref.options;
                final selectedId = c.selectedBudgetId.value;
                final customText = c.customBudgetText.value;

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

                      // 🟢 Custom text input for custom range
                      _customField(
                        initial: customText,
                        onChanged: (v) => c.customBudgetText.value = v,
                      ),
                      const SizedBox(height: 18),

                      // 🟢 List of budget chips (from API)
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: budgets
                            .map(
                              (b) => _budgetChip(
                                b.rangeText ?? b.label ?? '',
                                selected: selectedId == b.id,
                                onTap: () {
                                  c.selectedBudgetId.value = b.id;
                                  c.customBudgetText.value =
                                      ''; // clear custom text
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }),
            ),

            // 🟢 Continue button
            Obx(
              () => PrimaryBarButton(
                onTap: () async {
                  await c.submitBudget();
                  Get.offAllNamed(Routes.prefsStart);
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

  static Widget _customField({
    required String initial,
    required ValueChanged<String> onChanged,
  }) {
    final controller = TextEditingController(text: initial);
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: '\$ 200 - 250',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, right: 12),
          child: Icon(Icons.attach_money, color: _teal),
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

  static Widget _budgetChip(
    String text, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF99B3B2) : _chipBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF2F6767),
          ),
        ),
      ),
    );
  }
}
