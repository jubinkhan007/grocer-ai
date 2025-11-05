// lib/features/orders/views/new_order_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/controllers/new_order_controller.dart';
import 'package:grocer_ai/features/orders/models/order_preference_model.dart';
import 'package:grocer_ai/features/orders/views/store_order_screen.dart';
import 'package:grocer_ai/shell/main_shell_controller.dart';

import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';

class NewOrderScreen extends GetView<NewOrderController> {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the shell controller to manage the bottom nav state
    final shellController = Get.find<MainShellController>();
    final padTop = MediaQuery.of(context).padding.top;
    const _teal = Color(0xFF33595B);
    const _toolbar = 56.0;
    // Figma page background
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header bar exactly like Figma (unchanged)
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: _teal,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                // total height = status bar + 56 (Figma)
                collapsedHeight: _toolbar,
                expandedHeight:  _toolbar,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  color: _teal,
                  padding: EdgeInsets.only(top: padTop), // covers the notch only
                  child: SizedBox(
                    height: _toolbar,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          const BackButton(color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            'New order',
                            style: TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          // notification pill (kept)
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _teal,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(Icons.notifications_none_rounded,
                                    size: 20, color: Colors.white),
                                Positioned(
                                  right: -1,
                                  top: -1,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBA4012),
                                      borderRadius: BorderRadius.circular(99),
                                      border: Border.all(color: _teal, width: 1.5),
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
                ),
              ),

              // --- MODIFIED: DYNAMIC CONTENT ---
              Obx(() {
                if (controller.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Build dynamic cards from API ---
                        ...controller.preferences
                            .map((pref) => _buildPreferenceCard(pref))
                            .toList(),
                        // --- End of dynamic cards ---

                        // Participating stores header (static, unchanged)
                        const Text(
                          'Please click on the participating grocery store for the\n'
                              'grocerAI-generated order list',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Store boxes (static, unchanged)
                        Obx(() {
                          final sel = controller.selectedStore.value;
                          return Row(
                            children: [
                              Expanded(
                                child: _StoreBox(
                                  label: 'Walmart',
                                  selected: sel == 'Walmart',
                                  onTap: () => controller.selectStore('Walmart'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StoreBox(
                                  label: 'Kroger',
                                  selected: sel == 'Kroger',
                                  onTap: () => controller.selectStore('Kroger'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StoreBox(
                                  label: 'Aldi',
                                  selected: sel == 'Aldi',
                                  onTap: () => controller.selectStore('Aldi'),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 24),

                        // Continue button (wired to controller)
                        Center(
                          child: SizedBox(
                            width: 382,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.onContinue, // <-- Wired up
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF33595B),
                                foregroundColor: const Color(0xFFFEFEFE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),

          // --- MODIFIED: Bottom nav now uses ShellController ---
          Align(
            alignment: Alignment.bottomCenter,
                      child: Obx(() => FFBottomNav(
                  currentIndex: shellController.current.value,
                  onTap: (i) {
                   // 1) switch the tab in the shell controller
                    shellController.goTo(i);

                    // 2) reveal the shell by popping this overlay page
                    //    (works whether you used Navigator or Get to push)
                    final root = Navigator.of(context, rootNavigator: true);
                    if (root.canPop()) {
                      root.popUntil((route) {
                        // If your MainShell has a named route, prefer that:
                        // return route.settings.name == MainShell.routeName;
                        return route.isFirst; // shell is the root
                      });
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  /// --- NEW: Helper to build dynamic cards ---
  Widget _buildPreferenceCard(OrderPreferenceItem pref) {
    // --- 'single' choice (Yes/No) ---
    if (pref.preferenceType == 'single') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: _CardBlockFigma(
          title: pref.title,
          child: Obx(() {
            final selectedOptionId = controller.answers[pref.id];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pref.options.map((opt) {
                    return _RadioPillFigma(
                      label: opt.label.capitalizeFirst ?? opt.label,
                      selected: selectedOptionId == opt.id,
                      onTap: () => controller.selectOption(pref.id, opt.id),
                    );
                  }).toList(),
                ),
                // Show upload button if this pref triggers it
                if (controller.shouldShowUpload(pref)) ...[
                  const SizedBox(height: 16),
                  _UploadBtnFigma(
                    label: 'Upload receipt',
                    onTap: () => controller.uploadReceipt(
                      pref.id,
                      selectedOptionId: controller.answers[pref.id] as int?,
                    ),
                  ),
                  // 👇 show files for this preference
                  Obx(() => _FileChips(
                    files: controller.filesByPref[pref.id] ?? const [],
                    onTap: controller.openFile,
                  )),
                ],
              ],
            );
          }),
        ),
      );
    }

    // --- 'text' input ---
    if (pref.preferenceType == 'text') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pref.title,
              style: const TextStyle(
                color: Color(0xFF212121),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 140,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEFEFE),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.topLeft,
              child: TextField(
                controller: controller.getTextController(pref),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                  pref.helpText ?? 'Share any additional info here...',
                ),
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink(); // Fallback for unknown types
  }
}

/// ----------------------- FIGMA-STYLED PARTS (Unchanged) -----------------------

class _CardBlockFigma extends StatelessWidget {
  const _CardBlockFigma({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF212121),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _RadioPillFigma extends StatelessWidget {
  const _RadioPillFigma({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: ShapeDecoration(
          color: const Color(0xFFF5F5F5),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // custom radio
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected
                        ? const Color(0xFF33595B)
                        : const Color(0xFFB7BFC0),
                    width: 2),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                  selected ? const Color(0xFF33595B) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF212121),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadBtnFigma extends StatelessWidget {
  const _UploadBtnFigma({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.upload_rounded,
            size: 18, color: Color(0xFFE9E9E9)),
        label: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE9E9E9),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF33595B),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          elevation: 0,
        ),
      ),
    );
  }
}

class _StoreBox extends StatelessWidget {
  const _StoreBox({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  String _assetFor(String name) {
    switch (name.toLowerCase()) {
      case 'walmart': return 'assets/images/walmart.png';
      case 'kroger':  return 'assets/images/kroger.png';
      case 'aldi':    return 'assets/images/aldi.png';
      default:        return 'assets/images/store.png';
    }
  }

  Size _logoSize(String name) {
    switch (name.toLowerCase()) {
      case 'walmart': return const Size(24, 24);
      case 'kroger':  return const Size(24, 13.5);
      case 'aldi':    return const Size(20, 24);
      default:        return const Size(24, 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = _assetFor(label);
    final logoSize = _logoSize(label);

    final Color bg = selected ? const Color(0xFFFEFEFE) : const Color(0xFFD0DADC);
    final BorderSide side = selected
        ? const BorderSide(color: Color(0xFF33595B), width: 2)
        : BorderSide.none;

    return SizedBox(
      width: 116,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: side, // <-- fixed
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24, height: 24,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      asset,
                      width: logoSize.width, height: logoSize.height,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.store, size: 20, color: Color(0xFF33595B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1, softWrap: false, overflow: TextOverflow.fade,
                    style: const TextStyle(
                      color: Color(0xFF33595B),
                      fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// (This class is no longer needed as state is in the controller)
// class _ReceiptFile {
//   final String name;
//   final int sizeKb;
//   _ReceiptFile({required this.name, required this.sizeKb});
// }

class _FileChips extends StatelessWidget {
  const _FileChips({required this.files, required this.onTap});
  final List<PreferenceFile> files;
  final void Function(PreferenceFile f) onTap;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: files.map((f) {
          final name = f.url.split('/').last;
          return InkWell(
            onTap: () => onTap(f),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.insert_drive_file, size: 16, color: Color(0xFF33595B)),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF33595B),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}
