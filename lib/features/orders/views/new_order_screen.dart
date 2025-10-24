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
  int _tab = 2;

  // Defaults chosen to match the Figma screenshots
  bool outsidePurchase = true;   // Yes
  bool awayFromHome = false;     // No
  bool guestsThisCycle = false;  // No

  final TextEditingController _note =
  TextEditingController(text: 'Yes, I do have.');
  final List<_ReceiptFile> _receipts = [];

  @override
  Widget build(BuildContext context) {
    // Figma page background
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header bar exactly like Figma (teal, 24px side padding, 20px vertical)
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF33595B),
                collapsedHeight: 88, // ~ SafeArea top + 20 padding + content height
                toolbarHeight: 88,
                titleSpacing: 0,
                title: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  color: const Color(0xFF33595B),
                  child: SafeArea(
                    bottom: false,
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
                        // notification pill 32x32 with bell (matches Figma touch target)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF33595B),
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
                                    border: Border.all(
                                        color: const Color(0xFF33595B),
                                        width: 1.5),
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

              // Content column at x=24, width=382 as in Figma
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(24, 24 /* top = 135 in figma minus header*/, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card 1: Outside purchase
                      _CardBlockFigma(
                        title:
                        'Any outside purchase to report since your last order with GrocerAI?',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _RadioPillFigma(
                                  label: 'Yes',
                                  selected: outsidePurchase,
                                  onTap: () =>
                                      setState(() => outsidePurchase = true),
                                ),
                                _RadioPillFigma(
                                  label: 'No',
                                  selected: !outsidePurchase,
                                  onTap: () =>
                                      setState(() => outsidePurchase = false),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _UploadBtnFigma(
                              label: 'Upload receipt',
                              onTap: () => setState(() {
                                _receipts.add(_ReceiptFile(
                                    name: 'receipt_${_receipts.length + 1}.pdf',
                                    sizeKb: 420));
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card 2: Away from home
                      _CardBlockFigma(
                        title:
                        'Are you planning to be out of home for days?',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _RadioPillFigma(
                              label: 'Yes',
                              selected: awayFromHome,
                              onTap: () =>
                                  setState(() => awayFromHome = true),
                            ),
                            _RadioPillFigma(
                              label: 'No',
                              selected: !awayFromHome,
                              onTap: () =>
                                  setState(() => awayFromHome = false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card 3: Guests
                      _CardBlockFigma(
                        title:
                        'Are you expecting guests this order cycle?',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _RadioPillFigma(
                              label: 'Yes',
                              selected: guestsThisCycle,
                              onTap: () =>
                                  setState(() => guestsThisCycle = true),
                            ),
                            _RadioPillFigma(
                              label: 'No',
                              selected: !guestsThisCycle,
                              onTap: () =>
                                  setState(() => guestsThisCycle = false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Extra info block (static text to match screenshot)
                      Text(
                        'Do you have any additional information to share?',
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
                        child: Text(
                          _note.text,
                          style: const TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Participating stores header
                      Text(
                        'Please click on the participating grocery store for the\n'
                            'grocerAI-generated order list',
                        style: const TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Three 116px-wide store pills with 25px spacing (as in Figma)
                      Row(
                        children: const [
                          Expanded(child: _StoreBox(label: 'Walmart', dimmedBg: true)),
                          SizedBox(width: 12), // visual spacing similar to figma
                          Expanded(child: _StoreBox(label: 'Kroger')),
                          SizedBox(width: 12),
                          Expanded(child: _StoreBox(label: 'Aldi')),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Continue button (382x56, radius 100)
                      Center(
                        child: SizedBox(
                          width: 382,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _onContinue,
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
              ),
            ],
          ),

          // Bottom nav (shadow + safe area gap is handled inside component)
          Align(
            alignment: Alignment.bottomCenter,
            child: FFBottomNav(
              currentIndex: _tab,
              onTap: (i) => setState(() => _tab = i),
            ),
          ),
        ],
      ),
    );
  }

  void _onContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StoreOrderScreen()),
    );
  }
}

/// ----------------------- FIGMA-STYLED PARTS -----------------------

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
                  color: selected ? const Color(0xFF33595B) : Colors.transparent,
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
        icon: const Icon(Icons.upload_rounded, size: 18, color: Color(0xFFE9E9E9)),
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
  const _StoreBox({required this.label, this.dimmedBg = false});
  final String label;
  final bool dimmedBg;

  String _assetFor(String name) {
    switch (name.toLowerCase()) {
      case 'walmart': return 'assets/images/walmart.png';
      case 'kroger':  return 'assets/images/kroger.png';
      case 'aldi':    return 'assets/images/aldi.png';
      default:        return 'assets/images/store.png';
    }
  }

  // Match logo proportions from the mock
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

    return SizedBox(
      width: 116, // fixed card width per Figma
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 20),
        decoration: ShapeDecoration(
          color: dimmedBg ? const Color(0xFFD0DADC) : const Color(0xFFFEFEFE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo (24-wide slot)
            SizedBox(
              width: 24,
              height: 24,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(
                  asset,
                  width: logoSize.width,
                  height: logoSize.height,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.store, size: 20, color: Color(0xFF33595B)),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Brand name (fits in remaining width)
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: Color(0xFF33595B),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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
