// lib/features/profile/preferences/views/preferences_screen.dart

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
const _familyRowLabel = Color(0xFF4D4D4D); // "Adults" etc in view mode card
const _familyEditLabel = Color(0xFF414141); // label in edit mode rows
const _chipBg = Color(0xFFF5F5F5); // default chip bg
const _chipSelectedBg = Color(0xFFD0DADC); // selected chip bg IN EDIT MODE
const _cardBg = Colors.white;
const _dividerStroke = Color(0xFFE0E0E0); // only used in the old layout
// NOTE: Figma doesn't actually draw these dividers in edit mode anymore,
// but we'll keep the token around just in case we need it.

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreferencesController>();

    // Match light status content on dark #002C2E bar behind SafeArea
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

        // 👇 Force GetX to subscribe to these reactive fields
        final dietRev = c.selectedDietIds.length;
        final cuisineRev = c.selectedCuisineIds.length;
        final freqRev = c.selectedFrequencyId.value;

        return Column(
          children: [
            // Top chrome: dark status bar strip + teal header bar
            _PreferencesHeader(
              isEditing: isEditing,
              onBack: () {
                Navigator.of(context).pop(); // <- use the local Navigator
              },
              onTapEdit: () {
                if (!c.isEditing.value) {
                  c.isEditing.value = true;
                }
              },
            ),


            // Scrollable body
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Intro paragraph (14 / 400 / #212121)
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

                          /// ===== 1. FAMILY SIZE =====
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

                          /// ===== 2. DIETARY PREFERENCE =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle('What is your dietary preference?'),
                                const SizedBox(height: 16),
                                _ChipsWrap(
                                  key: ValueKey('diet_$dietRev'),
                                  options: c.diet?.options ?? const [],
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

                          /// ===== 3. CUISINE PREFERENCE =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle('What is your cuisine preference?'),
                                const SizedBox(height: 16),
                                _ChipsWrap(
                                  key: ValueKey('cuisine_$cuisineRev'),
                                  options: c.cuisine?.options ?? const [],
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

                          /// ===== 4. DIETARY RESTRICTIONS =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle(
                                    'Do you have any dietary restrictions?'),
                                const SizedBox(height: 16),
                                _StaticChipWrap(
                                  chips: isEditing
                                      ? const [
                                    _StaticChipData('Vegetarian'),
                                    _StaticChipData('Vegan'),
                                    _StaticChipData('Gluten-Free'),
                                    _StaticChipData('Low-Carb'),
                                    _StaticChipData('Low-Fat'),
                                    _StaticChipData('Dairy-Free'),
                                    _StaticChipData('Nut-Free', selected: true),
                                    _StaticChipData('Pescatarian'),
                                    _StaticChipData('Keto'),
                                    _StaticChipData('Paleo'),
                                    _StaticChipData('High-Protein'),
                                  ]
                                      : const [
                                    _StaticChipData('Nut-Free', selected: true),
                                  ],
                                  editable: isEditing,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// ===== 5. ALLERGIES =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle('Do you have any allergies?'),
                                const SizedBox(height: 16),
                                _StaticChipWrap(
                                  chips: isEditing
                                      ? const [
                                    _StaticChipData('Diary'),
                                    _StaticChipData('Nut'),
                                    _StaticChipData('Seafood'),
                                    _StaticChipData('Gluten', selected: true),
                                    _StaticChipData('Soy'),
                                    _StaticChipData('Egg'),
                                  ]
                                      : const [
                                    _StaticChipData('Gluten', selected: true),
                                  ],
                                  editable: isEditing,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// ===== 6. SPICE LEVEL =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle(
                                    'How adventurous are you with spice?'),
                                const SizedBox(height: 16),
                                _StaticChipWrap(
                                  chips: isEditing
                                      ? const [
                                    _StaticChipData('Mild'),
                                    _StaticChipData('Medium'),
                                    _StaticChipData('Spicy', selected: true),
                                  ]
                                      : const [
                                    _StaticChipData('Spicy', selected: true),
                                  ],
                                  editable: isEditing,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// ===== 7. COOK TIME =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle(
                                    'How much time do you prefer to spend on preparing a meal?'),
                                const SizedBox(height: 16),
                                _StaticChipWrap(
                                  chips: isEditing
                                      ? const [
                                    _StaticChipData('15-30 mins'),
                                    _StaticChipData('30-45 mins',
                                        selected: true),
                                    _StaticChipData('45 mins & above'),
                                  ]
                                      : const [
                                    _StaticChipData('30-45 mins',
                                        selected: true),
                                  ],
                                  editable: isEditing,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// ===== 8. SHOPPING FREQUENCY =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle(
                                    'What is your shopping frequency?'),
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
                                      options: c.frequency?.options ?? const [],
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

                          /// ===== 9. COMFORT LEVEL =====
                          _CardShell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _CardTitle(
                                    "What's your comfort level in the kitchen?"),
                                const SizedBox(height: 16),
                                _StaticChipWrap(
                                  chips: isEditing
                                      ? const [
                                    _StaticChipData('Beginner'),
                                    _StaticChipData('Intermediate'),
                                    _StaticChipData('Advanced'),
                                  ]
                                      : const [
                                    _StaticChipData('Intermediate',
                                        selected: true),
                                  ],
                                  editable: isEditing,
                                ),
                              ],
                            ),
                          ),

                          // Save pill at the bottom in edit mode
                          if (isEditing) ...[
                            const SizedBox(height: 24),
                            _SaveButtonPill(
                              onSave: () async {
                                await c.submitHousehold();
                                await c.submitDiet();
                                await c.submitCuisine();
                                await c.submitFrequency();
                                c.isEditing.value = false;
                                Get.snackbar(
                                  'Saved',
                                  'Preferences updated successfully',
                                );
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
/// Dark status strip (#002C2E) + teal app bar (#33595B)
/// View mode: back chevron + "Preferences" + "✎ Edit"
/// Edit mode: back chevron + "Preferences" (no Edit chip)
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
        // Dark teal behind iOS/Android status bar
        Container(
          color: _tealStatus,
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: SafeArea(
            bottom: false,
            child: const SizedBox(height: 0), // we rely on OS status bar height
          ),
        ),

        // Main teal header
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
                // back chevron
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

                // title + (optional) Edit
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

                      // Edit chip only in view mode
                      if (!isEditing)
                        InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: onTapEdit,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: _tealHeader,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Color(0xFFFEFEFE),
                                ),
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
/// Figma: white bg, radius 8, padding 16
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

/// Section title in every card
/// 16 / 500 / #212121 / Roboto
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
/// Each row: 36x36 icon tile (#E6EAEB bg, teal icon),
/// label 14/500/#4D4D4D, then count 14/600/#212121
class _FamilySizeViewBlock extends StatelessWidget {
  const _FamilySizeViewBlock({required this.controller});
  final PreferencesController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FamilyViewRow(
          icon: Icons.group, // swap with exported Figma asset if you have it
          label: 'Adults',
          value: controller.adultCount.value,
        ),
        const SizedBox(height: 12),
        _FamilyViewRow(
          icon: Icons.child_care,
          label: 'Kids',
          value: controller.kidCount.value,
        ),
        const SizedBox(height: 12),
        _FamilyViewRow(
          icon: Icons.pets,
          label: 'Pets',
          value: controller.petCount.value,
        ),
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
        // 36x36 icon tile
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE6EAEB),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: _tealHeader,
          ),
        ),
        const SizedBox(width: 12),

        // label
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

        // count
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
/// Figma shows each row as a rounded 60px pill bg #F5F5F5,
/// with "Adults" and then [-] (20x20 outline) count (+)
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
      // pill bg
      decoration: BoxDecoration(
        color: _chipBg,
        borderRadius: BorderRadius.circular(60),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // label
            Text(
              label,
              style: const TextStyle(
                color: _familyEditLabel,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.44,
                fontFamily: 'SF Pro Display', // matches plugin text block
              ),
            ),

            // counter cluster
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

/// 20x20 circle outline button in teal
class _CircleStrokeBtn20 extends StatelessWidget {
  const _CircleStrokeBtn20({
    required this.icon,
    required this.onTap,
  });

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
          border: Border.all(
            color: _tealHeader,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 16,
          color: _tealHeader,
        ),
      ),
    );
  }
}

/// ======================================================================
/// GENERIC CHIP RENDERING (dynamic, backed by controller options)
/// - View mode: only selected chips are shown, all chips look like F5F5F5
/// - Edit mode: ALL chips, selected get bg #D0DADC
class _ChipsWrap extends StatelessWidget {
  const _ChipsWrap({
    super.key,
    required this.options,
    required this.selectedIds,
    required this.editable,
    required this.onTapChip,
    this.singleSelect = false,
  });

  final List<dynamic> options; // each option has .id and .label
  final Set<int> selectedIds;
  final bool editable;
  final bool singleSelect;
  final void Function(dynamic opt) onTapChip;

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
            label: opt.label ?? '',
            selected: selectedIds.contains(opt.id),
            editable: editable,
            onTap: () => onTapChip(opt),
          ),
      ],
    );
  }
}

/// Same visual chip but for static data (restrictions, etc.) where
/// we don't have controller objects yet.
class _StaticChipWrap extends StatelessWidget {
  const _StaticChipWrap({
    required this.chips,
    required this.editable,
  });

  final List<_StaticChipData> chips;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final chip in chips)
          _PrefChip(
            label: chip.label,
            selected: chip.selected,
            editable: editable,
            onTap: () {
              // not wired yet
            },
          ),
      ],
    );
  }
}

class _StaticChipData {
  final String label;
  final bool selected;
  const _StaticChipData(this.label, {this.selected = false});
}

/// Pill chip (radius 60, padding horiz 16 vert 10)
/// - bg F5F5F5 normally
/// - bg D0DADC if (editable && selected)
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
    final Color bgColor =
    (editable && selected) ? _chipSelectedBg : _chipBg;

    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: editable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(60),
        ),
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
/// SAVE BUTTON (edit mode only)
/// Figma: full-width pill, height 56, radius 100, bg #33595B, text
/// white 16/600 centered
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
class _ComfortLevelWrap extends StatelessWidget {
  const _ComfortLevelWrap({
    required this.controller,
    required this.editable,
  });

  final PreferencesController controller;
  final bool editable;

  static const _options = <String>[
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  Widget build(BuildContext context) {
    // In view mode: show only the chosen chip.
    // In edit mode: show all three.
    return Obx(() {
      final current = controller.comfortLevel.value;

      final visibleLabels = editable
          ? _options
          : _options.where((label) => label == current).toList();

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final label in visibleLabels)
            _PrefChip(
              label: label,
              selected: label == current,
              editable: editable,
              onTap: editable
                  ? () {
                controller.comfortLevel.value = label;
                controller.submitComfortLevel();
              }
                  : () {},
            ),
        ],
      );
    });
  }
}
