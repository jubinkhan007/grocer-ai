import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../preferences/preferences_controller.dart';

/// ===== FIGMA TOKENS / COLORS =====
const _bgPage = Color(0xFFF4F6F6); // page background
const _tealStatus = Color(0xFF002C2E); // dark strip behind status bar
const _tealHeader = Color(0xFF33595B); // app bar + buttons
const _textPrimary = Color(0xFF212121);
const _textSecondary = Color(0xFF4D4D4D);
const _familyRowLabel = Color(0xFF4D4D4D);
const _familyEditLabel = Color(0xFF414141);
const _chipBg = Color(0xFFF5F5F5);
const _chipSelectedBg = Color(0xFFD0DADC);
const _cardBg = Colors.white;

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreferencesController>();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _tealStatus,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: _bgPage,
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final isEditing = c.isEditing.value;

        // Triggers for Obx rebuilds
        final dietRev = c.selectedDietIds.length;
        final cuisineRev = c.selectedCuisineIds.length;
        final freqRev = c.selectedFrequencyId.value;
        final budgetRev = c.selectedBudgetId.value;
        final allergyRev = c.selectedAllergyIds.length;

        return Column(
          children: [
            _PreferencesHeader(
              isEditing: isEditing,
              onBack: () => Navigator.of(context).pop(),
              onTapEdit: () {
                if (!c.isEditing.value) c.isEditing.value = true;
              },
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select your preferences below to unlock a world of personalized dishes and delightful culinary content crafted just for you.',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                              fontFamily: 'Roboto',
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// ===== 1) HOUSEHOLD (only if API provides it) =====
                          if (c.house != null) ...[
                            _CardShell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _CardTitle('What is your family size?'),
                                  const SizedBox(height: 16),
                                  isEditing
                                      ? _FamilySizeEditBlock(controller: c)
                                      : _FamilySizeViewBlock(controller: c),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          /// ===== 2) DIET =====
                          if (c.diet != null) ...[
                            _CardShell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _CardTitle('What is your dietary preference?'),
                                  const SizedBox(height: 16),
                                  _ChipsWrap(
                                    key: ValueKey('diet_$dietRev'),
                                    options: c.diet!.options,
                                    selectedIds: c.selectedDietIds,
                                    editable: isEditing,
                                    onTapChip: (opt) {
                                      if (!isEditing) return;
                                      if (c.selectedDietIds.contains(opt.id)) {
                                        c.selectedDietIds.remove(opt.id);
                                      } else {
                                        c.selectedDietIds.add(opt.id);
                                      }
                                      c.submitDiet();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          /// ===== 3) CUISINE =====
                          if (c.cuisine != null) ...[
                            _CardShell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _CardTitle('What is your cuisine preference?'),
                                  const SizedBox(height: 16),
                                  _ChipsWrap(
                                    key: ValueKey('cuisine_$cuisineRev'),
                                    options: c.cuisine!.options,
                                    selectedIds: c.selectedCuisineIds,
                                    editable: isEditing,
                                    onTapChip: (opt) {
                                      if (!isEditing) return;
                                      if (c.selectedCuisineIds.contains(opt.id)) {
                                        c.selectedCuisineIds.remove(opt.id);
                                      } else {
                                        c.selectedCuisineIds.add(opt.id);
                                      }
                                      c.submitCuisine();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          /// ===== 4) ALLERGIES (optional per API) =====
                          if (c.allergies != null) ...[
                            _CardShell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _CardTitle('Do you have any allergies?'),
                                  const SizedBox(height: 16),
                                  _ChipsWrap(
                                    key: ValueKey('allergy_$allergyRev'), // <-- ADD KEY
                                    options: c.allergies!.options,
                                    selectedIds: c.selectedAllergyIds,     // <-- reactive RxSet
                                    editable: isEditing,
                                    onTapChip: (opt) {
                                      if (!isEditing) return;
                                      if (c.selectedAllergyIds.contains(opt.id)) {
                                        c.selectedAllergyIds.remove(opt.id);
                                      } else {
                                        c.selectedAllergyIds.add(opt.id);
                                      }
                                      c.submitAllergies();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          /// ===== 5) FREQUENCY =====
                          if (c.frequency != null) ...[
                            _CardShell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _CardTitle('What is your shopping frequency?'),
                                  const SizedBox(height: 16),
                                  Builder(
                                    builder: (_) {
                                      final selectedFreqIds = <int>{};
                                      if (c.selectedFrequencyId.value != null) {
                                        selectedFreqIds
                                            .add(c.selectedFrequencyId.value!);
                                      }
                                      return _ChipsWrap(
                                        key: ValueKey('freq_$freqRev'),
                                        options: c.frequency!.options,
                                        selectedIds: selectedFreqIds,
                                        editable: isEditing,
                                        singleSelect: true,
                                        onTapChip: (opt) {
                                          if (!isEditing) return;
                                          c.selectedFrequencyId.value = opt.id;
                                          c.submitFrequency();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          /// ===== 6) BUDGET (Spending limit per week) =====
                          if (c.budget != null) ...[
                            _CardShell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _CardTitle('Spending limit per week'),
                                  const SizedBox(height: 16),
                                  _ChipsWrap(
                                    key: ValueKey('budget_$budgetRev'),
                                    options: c.budget!.options,
                                    selectedIds: {
                                      if (c.selectedBudgetId.value != null)
                                        c.selectedBudgetId.value!,
                                    },
                                    editable: isEditing,
                                    singleSelect: true,
                                    // show range_text when label is null
                                    onTapChip: (opt) {
                                      if (!isEditing) return;
                                      c.selectedBudgetId.value = opt.id;
                                      c.submitBudget();
                                    },
                                    labelResolver: (opt) =>
                                    opt.label ?? (opt.rangeText ?? ''),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Note: restrictions, spice, cook-time, comfort
                          // are intentionally omitted because the API does not
                          // return them. We only render what exists.

                          // Save pill at the bottom in edit mode
                          if (isEditing) ...[
                            const SizedBox(height: 24),
                            _SaveButtonPill(
                              onSave: () async {
                                final steps = <Future<bool> Function()>[
                                  c.submitHousehold,
                                  c.submitDiet,
                                  c.submitCuisine,
                                  c.submitFrequency,
                                  c.submitBudget,
                                  c.submitAllergies,
                                  // IMPORTANT: do not enforce mandatory when saving from the footer,
                                  // because this section isn’t shown in the UI.
                                      () => c.submitGrocers(enforce: false),
                                ];

                                for (final step in steps) {
                                  final ok = await step();
                                  if (!ok) return; // an error snackbar was already shown
                                }

                                c.isEditing.value = false;
                                Get.snackbar('Saved', 'Preferences updated successfully');
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// ======================================================================
/// HEADER
class _PreferencesHeader extends StatelessWidget {
  const _PreferencesHeader({
    required this.isEditing,
    required this.onBack,
    required this.onTapEdit,
  });

  final bool isEditing;
  final VoidCallback onBack;
  final VoidCallback onTapEdit;

  @override
  Widget build(BuildContext context) {
    final vPad = isEditing ? 20.0 : 14.0;
    final barHeight = isEditing ? null : 63.0;

    return Column(
      children: [
        Container(
          color: _tealStatus,
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: SafeArea(bottom: false, child: const SizedBox(height: 0)),
        ),
        Container(
          width: double.infinity,
          height: barHeight,
          color: _tealHeader,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: vPad),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: onBack,
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Color(0xFFFEFEFE),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Preferences',
                        style: TextStyle(
                          color: Color(0xFFFEFEFE),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      if (!isEditing)
                        InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: onTapEdit,
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                            decoration: BoxDecoration(
                              color: _tealHeader,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.edit, size: 16, color: Color(0xFFFEFEFE)),
                                SizedBox(width: 4),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Color(0xFFFEFEFE),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ======================================================================
/// CARD WRAPPER
class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

/// Section title
class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.3,
        fontFamily: 'Roboto',
      ),
    );
  }
}

/// ======================================================================
/// FAMILY SIZE VIEW MODE
class _FamilySizeViewBlock extends StatelessWidget {
  const _FamilySizeViewBlock({required this.controller});
  final PreferencesController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FamilyViewRow(icon: Icons.group, label: 'Adults', value: controller.adultCount.value),
        const SizedBox(height: 12),
        _FamilyViewRow(icon: Icons.child_care, label: 'Kids', value: controller.kidCount.value),
        const SizedBox(height: 12),
        _FamilyViewRow(icon: Icons.pets, label: 'Pets', value: controller.petCount.value),
      ],
    );
  }
}

class _FamilyViewRow extends StatelessWidget {
  const _FamilyViewRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE6EAEB),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: _tealHeader),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: _familyRowLabel,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.3,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}

/// ======================================================================
/// FAMILY SIZE EDIT MODE
class _FamilySizeEditBlock extends StatelessWidget {
  const _FamilySizeEditBlock({required this.controller});
  final PreferencesController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FamilyEditPillRow(
          label: 'Adults',
          count: controller.adultCount,
          onMinus: () {
            if (controller.adultCount.value > 0) {
              controller.adultCount.value--;
              controller.syncHouseholdMap();
            }
          },
          onPlus: () {
            controller.adultCount.value++;
            controller.syncHouseholdMap();
          },
        ),
        const SizedBox(height: 8),
        _FamilyEditPillRow(
          label: 'Kids',
          count: controller.kidCount,
          onMinus: () {
            if (controller.kidCount.value > 0) {
              controller.kidCount.value--;
              controller.syncHouseholdMap();
            }
          },
          onPlus: () {
            controller.kidCount.value++;
            controller.syncHouseholdMap();
          },
        ),
        const SizedBox(height: 8),
        _FamilyEditPillRow(
          label: 'Pets',
          count: controller.petCount,
          onMinus: () {
            if (controller.petCount.value > 0) {
              controller.petCount.value--;
              controller.syncHouseholdMap();
            }
          },
          onPlus: () {
            controller.petCount.value++;
            controller.syncHouseholdMap();
          },
        ),
      ],
    );
  }
}

class _FamilyEditPillRow extends StatelessWidget {
  const _FamilyEditPillRow({
    required this.label,
    required this.count,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final RxInt count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _chipBg, borderRadius: BorderRadius.circular(60)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _familyEditLabel,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.44,
                fontFamily: 'SF Pro Display',
              ),
            ),
            Row(
              children: [
                _CircleStrokeBtn20(icon: Icons.remove, onTap: onMinus),
                const SizedBox(width: 8),
                Text(
                  '${count.value}',
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 8),
                _CircleStrokeBtn20(icon: Icons.add, onTap: onPlus),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleStrokeBtn20 extends StatelessWidget {
  const _CircleStrokeBtn20({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29),
          border: Border.all(color: _tealHeader, width: 1),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: _tealHeader),
      ),
    );
  }
}

/// ======================================================================
/// GENERIC CHIPS
class _ChipsWrap extends StatelessWidget {
  const _ChipsWrap({
    super.key,
    required this.options,
    required this.selectedIds,
    required this.editable,
    required this.onTapChip,
    this.singleSelect = false,
    this.labelResolver,
  });

  final List<dynamic> options; // PrefOption
  final Set<int> selectedIds;
  final bool editable;
  final bool singleSelect;
  final void Function(dynamic opt) onTapChip;

  /// Optional resolver to render label (e.g., pref.rangeText)
  final String Function(dynamic opt)? labelResolver;

  @override
  Widget build(BuildContext context) {
    final visibleChips = editable
        ? options
        : options.where((o) => selectedIds.contains(o.id)).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final opt in visibleChips)
          _PrefChip(
            label: labelResolver?.call(opt) ?? (opt.label ?? ''),
            selected: selectedIds.contains(opt.id),
            editable: editable,
            onTap: () => onTapChip(opt),
          ),
      ],
    );
  }
}

class _PrefChip extends StatelessWidget {
  const _PrefChip({
    required this.label,
    required this.selected,
    required this.editable,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool editable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = (editable && selected) ? _chipSelectedBg : _chipBg;

    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: editable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(60)),
        child: Text(
          label,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.3,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}

/// ======================================================================
/// SAVE BUTTON
class _SaveButtonPill extends StatelessWidget {
  const _SaveButtonPill({required this.onSave});
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        color: _tealHeader,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onSave,
          child: const Center(
            child: Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFFEFEFE),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.2,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
