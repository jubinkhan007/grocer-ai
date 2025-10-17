import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/views/store_order_screen.dart';

import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  // bottom nav index (Order tab)
  int _tab = 2;

  // -------- Local UI state (swap with controller later) ----------
  bool outsidePurchase = false; // yes = true, no = false
  bool awayFromHome = false;
  bool guestsThisCycle = false;

  final TextEditingController _note = TextEditingController(text: '');
  final List<_ReceiptFile> _receipts = []; // mocked “attachments”

  // weeks chooser (only visible when awayFromHome = true)
  final List<int> _pickedWeeks = [2]; // example default
  final List<int> _availableWeeks = [1, 2, 3, 4, 5, 6];

  // -------- Stubs for later integration ----------
  Future<void> _requestMediaPermission() async {
    // TODO: request permission through permission_handler
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _pickReceipt() async {
    // TODO: integrate file_picker or image_picker
    // For now, push a mocked file to show the UI
    setState(() {
      _receipts.add(
        _ReceiptFile(name: 'Order-${22 + _receipts.length}June.pdf', sizeKb: 600 - 60 * _receipts.length),
      );
    });
  }

  // ------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.teal,
            elevation: 0,
            pinned: true,
            collapsedHeight: 72,
            titleSpacing: 0,
            title: Container(
              color: AppColors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: const [
                    BackButton(color: Colors.white),
                    SizedBox(width: 4),
                    Text('New order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        )),
                    Spacer(),
                    Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 22),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                children: [
                  // 1) Outside purchase?
                  _CardBlock(
                    title: 'Any outside purchase to report since your last order with GrocerAI?',
                    trailing: _UploadRow(
                      hasFiles: _receipts.isNotEmpty,
                      onTap: () async {
                        // mimic Android-style permission prompt on first press
                        if (_receipts.isEmpty) {
                          await _showPermissionPrompt(context);
                          await _requestMediaPermission();
                        }
                        _pickReceipt();
                      },
                      label: _receipts.isEmpty ? 'Add receipt' : 'Add receipt',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _YesNo(
                          value: outsidePurchase,
                          onChanged: (v) => setState(() => outsidePurchase = v),
                        ),
                        if (_receipts.isNotEmpty) const SizedBox(height: 10),
                        ..._receipts.map((f) => _ReceiptTile(
                          file: f,
                          onRemove: () => setState(() => _receipts.remove(f)),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2) Away from home?
                  _CardBlock(
                    title: 'Are you planning to be out of home for days?',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _YesNo(
                          value: awayFromHome,
                          onChanged: (v) => setState(() => awayFromHome = v),
                        ),
                        if (awayFromHome) ...[
                          const SizedBox(height: 16),
                          const Text('How many weeks?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: -6,
                            children: _availableWeeks.map((w) {
                              final selected = _pickedWeeks.contains(w);
                              return ChoiceChip(
                                label: Text('${w == 1 ? '1 week' : '$w weeks'}'),
                                selected: selected,
                                onSelected: (_) {
                                  setState(() {
                                    if (selected) {
                                      _pickedWeeks.remove(w);
                                    } else {
                                      _pickedWeeks.add(w);
                                    }
                                  });
                                },
                                selectedColor: AppColors.teal.withOpacity(.12),
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: selected ? AppColors.teal : AppColors.subtext,
                                  fontWeight: FontWeight.w500,
                                ),
                                side: BorderSide.none,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.add, size: 18, color: AppColors.subtext),
                              const SizedBox(width: 6),
                              Text('Add preferable weeks',
                                  style: TextStyle(
                                      color: AppColors.teal.withOpacity(.9),
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3) Guests?
                  _CardBlock(
                    title: 'Are you expecting guests this order cycle?',
                    child: _YesNo(
                      value: guestsThisCycle,
                      onChanged: (v) => setState(() => guestsThisCycle = v),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4) Additional info
                  _CardBlock(
                    title: 'Do you have any additional information to share?',
                    child: Container(
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _note,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write here...',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 5) Participating stores (static)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Please click on the participating grocery store for the\n'
                          'grocerAI-generated order list',
                      style: TextStyle(
                        color: AppColors.subtext,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      _StorePill(label: 'Walmart', asset: 'assets/images/walmart.png'),
                      SizedBox(width: 12),
                      _StorePill(label: 'Kroger', asset: 'assets/images/kroger.png'),
                      SizedBox(width: 12),
                      _StorePill(label: 'Aldi', asset: 'assets/images/aldi.png'),
                    ],
                  ),
                  // spacer so the floating button doesn’t overlap
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),

      Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _onContinue, // see below
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
      ],
    ),
      bottomNavigationBar: FFBottomNav(
        currentIndex: _tab,
        onTap: (i) {
          setState(() => _tab = i);
          // TODO: switch root tabs via your router
        },
      ),
    );
  }

  void _onContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StoreOrderScreen()),
    );
  }



  Future<void> _showPermissionPrompt(BuildContext context) async {
    // simple sheet matching the mock
    return showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Allow access to files',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'This will help you to find photos and videos faster by '
                    'viewing your entire media gallery.',
                style: TextStyle(height: 1.35),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Deny')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: const Text('Allow'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =================== Small widgets ===================

class _CardBlock extends StatelessWidget {
  const _CardBlock({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 15.5, fontWeight: FontWeight.w700, height: 1.25)),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _YesNo extends StatelessWidget {
  const _YesNo({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        _RadioPill(
          label: 'Yes',
          selected: value == true,
          onTap: () => onChanged(true),
        ),
        _RadioPill(
          label: 'No',
          selected: value == false,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _RadioPill extends StatelessWidget {
  const _RadioPill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.teal.withOpacity(.1) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? AppColors.teal : AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? AppColors.teal : AppColors.subtext,
            ),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: selected ? AppColors.teal : AppColors.subtext,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _UploadRow extends StatelessWidget {
  const _UploadRow({required this.onTap, required this.label, this.hasFiles = false});
  final VoidCallback onTap;
  final String label;
  final bool hasFiles;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: hasFiles ? AppColors.teal : const Color(0xFFE7EFEF),
          foregroundColor: hasFiles ? Colors.white : AppColors.teal,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _ReceiptFile {
  final String name;
  final int sizeKb;
  _ReceiptFile({required this.name, required this.sizeKb});
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({required this.file, required this.onRemove});
  final _ReceiptFile file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_outlined, color: AppColors.subtext),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${file.sizeKb}KB',
                    style: const TextStyle(color: AppColors.subtext, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18, color: AppColors.subtext),
          ),
        ],
      ),
    );
  }
}

class _StorePill extends StatelessWidget {
  const _StorePill({required this.label, required this.asset});
  final String label;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                asset,
                width: 22,
                height: 22,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.store, size: 18, color: AppColors.teal),
              ),
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
