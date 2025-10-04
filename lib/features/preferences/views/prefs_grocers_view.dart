// lib/features/preferences/views/prefs_grocers_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../preferences_controller.dart';
import '../widgets/prefs_widgets.dart';
import '../../../app/app_routes.dart';

const _teal = Color(0xFF0C3E3D);
const _bg = Color(0xFFF1F4F6);
const _border = Color(0xFF2F6767);

class PrefsGrocersView extends GetView<PreferencesController> {
  const PrefsGrocersView({super.key});

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
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.error.value != null) {
                  return _Error(
                    onRetry: () => Get.offAllNamed(Routes.prefsStart),
                    msg: controller.error.value!,
                  );
                }
                final opt = controller.options.value!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Nearby Grocers',
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF33363E),
                            ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '(Select upto 3)',
                        style: TextStyle(
                          color: Color(0xFF6B737C),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: opt.grocers
                            .map(
                              (g) => _GrocerPill(
                                label: g.name,
                                selected: controller.selectedGrocers.contains(
                                  g.id,
                                ),
                                onTap: () {
                                  final ok = controller.toggleGrocer(g.id);
                                  if (!ok) {
                                    Get.snackbar(
                                      'Limit reached',
                                      'You can only select ${opt.grocerMax}.',
                                    );
                                  }
                                },
                                leading: g.logo == null
                                    ? null
                                    : Image.network(
                                        g.logo!,
                                        width: 28,
                                        height: 28,
                                        errorBuilder: (_, __, ___) =>
                                            const SizedBox.shrink(),
                                      ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }),
            ),
            PrimaryBarButton(
              onTap: () => Get.toNamed(Routes.prefsHouse),
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
}

class _GrocerPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  const _GrocerPill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? _teal : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _border, width: 1.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: leading,
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF33363E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;
  const _Error({required this.msg, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(msg, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
