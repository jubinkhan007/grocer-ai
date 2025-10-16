import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/theme/app_theme.dart';
import '../../../preferences/preferences_controller.dart';
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PreferencesController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select your preferences below to unlock a world of personalized dishes and delightful culinary content crafted just for you.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.subtext),
              ),
              const SizedBox(height: 24),

              _sectionTitle('What is your family size?'),
              _familySizeSection(controller),

              const SizedBox(height: 16),
              _sectionTitle('What is your dietary preference?'),
              _optionGroup(
                controller.diet?.options ?? [],
                controller.selectedDietIds,
                onTap: (opt) {
                  if (controller.selectedDietIds.contains(opt.id)) {
                    controller.selectedDietIds.remove(opt.id);
                  } else {
                    controller.selectedDietIds.add(opt.id);
                  }
                  controller.submitDiet();
                },
              ),

              const SizedBox(height: 16),
              _sectionTitle('What is your cuisine preference?'),
              _optionGroup(
                controller.cuisine?.options ?? [],
                controller.selectedCuisineIds,
                onTap: (opt) {
                  if (controller.selectedCuisineIds.contains(opt.id)) {
                    controller.selectedCuisineIds.remove(opt.id);
                  } else {
                    controller.selectedCuisineIds.add(opt.id);
                  }
                  controller.submitCuisine();
                },
              ),

              const SizedBox(height: 16),
              _sectionTitle('What is your shopping frequency?'),
              _optionGroup(
                controller.frequency?.options ?? [],
                {controller.selectedFrequencyId.value},
                singleSelect: true,
                onTap: (opt) {
                  controller.selectedFrequencyId.value = opt.id;
                  controller.submitFrequency();
                },
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.submitHousehold();
                    await controller.submitDiet();
                    await controller.submitCuisine();
                    await controller.submitFrequency();
                    Get.snackbar('Saved', 'Preferences updated successfully');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // section header
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  // family size section
  Widget _familySizeSection(PreferencesController c) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _counterRow('Adults', c.adultCount, onMinus: () {
            if (c.adultCount.value > 0) c.adultCount.value--;
            c.syncHouseholdMap();
          }, onPlus: () {
            c.adultCount.value++;
            c.syncHouseholdMap();
          }),
          const SizedBox(height: 8),
          _counterRow('Kids', c.kidCount, onMinus: () {
            if (c.kidCount.value > 0) c.kidCount.value--;
            c.syncHouseholdMap();
          }, onPlus: () {
            c.kidCount.value++;
            c.syncHouseholdMap();
          }),
          const SizedBox(height: 8),
          _counterRow('Pets', c.petCount, onMinus: () {
            if (c.petCount.value > 0) c.petCount.value--;
            c.syncHouseholdMap();
          }, onPlus: () {
            c.petCount.value++;
            c.syncHouseholdMap();
          }),
        ],
      ),
    );
  }

  Widget _counterRow(String label, RxInt value,
      {VoidCallback? onMinus, VoidCallback? onPlus}) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              _circleButton(Icons.remove, onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${value.value}',
                    style: const TextStyle(fontSize: 16)),
              ),
              _circleButton(Icons.add, onPlus),
            ],
          ),
        ],
      );
    });
  }

  Widget _circleButton(IconData icon, VoidCallback? onPressed) => InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.teal,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    ),
  );

  // option group (chips)
  Widget _optionGroup(
      List options,
      Set<int?> selected, {
        required Function(dynamic opt) onTap,
        bool singleSelect = false,
      }) {
    return Wrap(
      spacing: 8,
      runSpacing: -4,
      children: options.map<Widget>((opt) {
        final isSelected = selected.contains(opt.id);
        return ChoiceChip(
          label: Text(opt.label ?? ''),
          selected: isSelected,
          onSelected: (_) => onTap(opt),
          selectedColor: AppColors.teal.withOpacity(0.15),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.teal : AppColors.subtext,
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }
}
