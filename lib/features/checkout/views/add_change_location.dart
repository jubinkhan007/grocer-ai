// lib/features/checkout/views/add_change_location.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/checkout/controllers/checkout_controller.dart';
import 'package:grocer_ai/features/onboarding/location/models/user_location_model.dart';
import '../utils/design_tokens.dart';

// Screen to select or add a delivery location.
// Visually unchanged. Now fully wired to CheckoutController.
class SetNewLocationScreen extends GetView<CheckoutController> {
  const SetNewLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textCtrl = TextEditingController();
    final showSuggestions = false.obs;

    const suggestions = <String>[
      'Kansas City',
      'Knoxville',
      'Kalamazoo',
      'Kentucky',
      'Killeen',
      'Kingston',
    ];

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: statusTeal,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    void handleBack() {
      Get.back();
    }

    void handleClear() {
      textCtrl.clear();
      showSuggestions.value = false;
    }

    void handleTapSearchField() {
      showSuggestions.value = true;
    }

    // When user taps a suggestion: create that location + select + go back
    Future<void> handleSelectSuggestion(String value) async {
      textCtrl.text = value;
      showSuggestions.value = false;

      await controller.saveNewLocation(
        label: value,
        address: value,
      );

      if (!controller.isSavingLocation.value) {
        Get.back(); // go back to Checkout
      }
    }


    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          // STATUS STRIP
          Container(
            color: statusTeal,
            width: double.infinity,
            padding: EdgeInsets.zero,
            child: const SafeArea(
              bottom: false,
              child: SizedBox(height: 0),
            ),
          ),

          // APP BAR
          Container(
            width: double.infinity,
            color: headerTeal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: handleBack,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Color(0xFFFEFEFE),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Set new location',
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchPill(
                    controller: textCtrl,
                    onTap: handleTapSearchField,
                    onClear: handleClear,
                    onSubmitted: (value) async {
                      final addr = value.trim();
                      if (addr.isEmpty) return;

                      await controller.saveNewLocation(
                        label: addr,
                        address: addr,
                      );

                      // If it saved (no error thrown), go back to Checkout
                      if (!controller.isSavingLocation.value) {
                        Get.back();
                      }
                    },
                  ),


                  // suggestions dropdown
                  Obx(() {
                    if (!showSuggestions.value) {
                      return const SizedBox.shrink();
                    }

                    // simple filter to feel "searchy"
                    final q = textCtrl.text.trim().toLowerCase();
                    final filtered = q.isEmpty
                        ? suggestions
                        : suggestions
                        .where((s) =>
                        s.toLowerCase().contains(q))
                        .toList();

                    if (filtered.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        _SuggestionsDropdown(
                          items: filtered,
                          onSelect: handleSelectSuggestion,
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),

                  // Saved addresses list + "Add new address"
                  Obx(
                        () => _SavedAddressesBlock(
                      locations: controller.userLocations.toList(),
                      onSelectLocation: (id) {
                        controller.selectLocation(id);
                        Get.back(); // return to checkout
                      },
                      onAddNew: () {
                        Get.dialog(
                          _AddNewAddressDialog(),
                          barrierDismissible: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _AddNewAddressDialog extends StatelessWidget {
  _AddNewAddressDialog({super.key});

  final _labelCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _labelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Label (e.g., Home, Work)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value ?? '').isEmpty ? 'Label is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) =>
                (value ?? '').isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 24),
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: controller.isSavingLocation.value
                          ? null
                          : () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: headerTeal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: controller.isSavingLocation.value
                          ? null
                          : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await controller.saveNewLocation(
                            label: _labelCtrl.text.trim(),
                            address: _addressCtrl.text.trim(),
                          );

                          // If it completed (success or failure), just close the dialog.
                          if (!controller.isSavingLocation.value) {
                            Get.back(); // closes _AddNewAddressDialog only
                          }
                        }
                      },


                      child: controller.isSavingLocation.value
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== SEARCH PILL (visual only) ==========

class _SearchPill extends StatelessWidget {
  const _SearchPill({
    required this.controller,
    required this.onTap,
    required this.onClear,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: pillBg,
      borderRadius: BorderRadius.circular(128),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: headerTeal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onTap: onTap,
                onSubmitted: onSubmitted,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Search city',
                  hintStyle: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onClear,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ========== SUGGESTIONS DROPDOWN ==========

class _SuggestionsDropdown extends StatelessWidget {
  const _SuggestionsDropdown({
    required this.items,
    required this.onSelect,
  });

  final List<String> items;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: sheetShadow,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            InkWell(
              onTap: () => onSelect(items[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    items[i],
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
            if (i != items.length - 1)
              const Divider(
                height: 1,
                thickness: 0.0,
                color: Colors.transparent,
              ),
          ],
        ],
      ),
    );
  }
}

// ========== SAVED ADDRESSES BLOCK ==========

class _SavedAddressesBlock extends StatelessWidget {
  final List<UserLocation> locations;
  final ValueChanged<int> onSelectLocation;
  final VoidCallback onAddNew;

  const _SavedAddressesBlock({
    required this.locations,
    required this.onSelectLocation,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          // Existing saved locations
          ...locations.asMap().entries.map((entry) {
            final index = entry.key;
            final location = entry.value;

            IconData icon = Icons.location_on_outlined;
            final labelLower = location.label.toLowerCase();
            if (labelLower == 'home') {
              icon = Icons.home_outlined;
            } else if (labelLower == 'work') {
              icon = Icons.work_outline;
            }

            return _SavedAddressRow(
              bubbleIcon: icon,
              title: location.label,
              subtitle: location.address,
              showTopDivider: index != 0,
              onTap: () => onSelectLocation(location.id),
            );
          }),

          // "Add new address" row (always last)
          _SavedAddressRow(
            bubbleIcon: Icons.add,
            title: 'Add new address',
            subtitle: 'Tap to add a new location',
            showTopDivider: locations.isNotEmpty,
            onTap: onAddNew,
          ),
        ],
      ),
    );
  }
}

class _SavedAddressRow extends StatelessWidget {
  const _SavedAddressRow({
    required this.bubbleIcon,
    required this.title,
    required this.subtitle,
    required this.showTopDivider,
    required this.onTap,
  });

  final IconData bubbleIcon;
  final String title;
  final String subtitle;
  final bool showTopDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          if (showTopDivider)
            const Divider(
              height: 1,
              thickness: 1,
              color: dividerGrey,
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: bubbleBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    bubbleIcon,
                    size: 18,
                    color: headerTeal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: textSecondary,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
