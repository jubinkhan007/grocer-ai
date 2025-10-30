// lib/features/orders/views/store_order_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/controllers/store_order_controller.dart';
import 'package:grocer_ai/features/orders/models/generated_order_model.dart';
import '../../../ui/theme/app_theme.dart';
import '../widgets/related_items_sheet.dart';

// --- MODIFIED: Changed to GetView<StoreOrderController> ---
class StoreOrderScreen extends GetView<StoreOrderController> {
  const StoreOrderScreen({
    super.key,
    // These properties are now managed by the controller
    // this.storeName = 'Walmart',
    // this.currentTotal = '\$400',
    // this.oldTotal = '\$482',
    // this.fromCompare = false,
  });

  @override
  Widget build(BuildContext context) {
    // Scroll controller is now local to the build method
    final _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Stack(
        children: [
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 4,
            radius: const Radius.circular(40),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // --- MODIFIED: HEADER ---
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: const Color(0xFF33595B),
                  collapsedHeight: 88,
                  toolbarHeight: 88,
                  titleSpacing: 0,
                  title: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 8, 20),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          // Use Get.back() for navigation
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          // Dynamic Logo
                          Obx(() {
                            final logoUrl = controller.provider.value?.logo;
                            if (logoUrl == null || logoUrl.isEmpty) {
                              return Image.asset('assets/images/walmart.png', width: 24, height: 24); // Fallback
                            }
                            return Image.network(
                              logoUrl,
                              width: 24,
                              height: 24,
                              errorBuilder: (_, __, ___) => Image.asset('assets/images/walmart.png', width: 24, height: 24),
                            );
                          }),
                          const SizedBox(width: 8),
                          // Dynamic Title
                          Obx(() => Text(
                            controller.provider.value?.name ?? 'Store Order',
                            style: const TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: controller.onAddItem, // Use controller
                            icon: const Icon(Icons.add, color: Colors.white, size: 20),
                            label: const Text(
                              'Add item',
                              style: TextStyle(
                                color: Color(0xFFFEFEFE),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --- MODIFIED: ORDER HEADER ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Obx(() => Row(
                      children: [
                        const Text(
                          'Order',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF33595B),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            '${controller.products.length}', // Dynamic count
                            style: const TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _totalPill(
                          controller.provider.value?.discountedPrice ?? '\$0',
                          controller.provider.value?.totalPrice ?? '\$0',
                        ),
                      ],
                    )),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // --- MODIFIED: DYNAMIC LIST ---
                Obx(() => SliverList.separated(
                  itemCount: controller.products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final item = controller.products[i];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: controller.onDismissConfirm,
                      onDismissed: (_) => controller.onItemDismissed(item),
                      background: const _SwipeDeleteBackground(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _OrderRow(
                          item: item,
                          onMinus: () => controller.onQtyMinus(item),
                          onPlus: () => controller.onQtyPlus(item),
                          onTap: () => controller.onItemTap(item),
                        ),
                      ),
                    );
                  },
                )),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),

          // --- MODIFIED: CTA ---
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: controller.onCompareOrCheckout, // Use controller
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF33595B),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1915224F),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    // Dynamic button text
                    child: Obx(() => Text(
                      controller.fromCompare.value ? 'Checkout' : 'Compare Grocers',
                      style: const TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // $400 $482 pill (unchanged)
  Widget _totalPill(String now, String old) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE3E3),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Text(
            now, // Assumes $ is included from API
            style: const TextStyle(
              color: Color(0xFF33595B),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            old, // Assumes $ is included from API
            style: const TextStyle(
              color: Color(0xFF33595B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}

// --- MODIFIED: _OrderRow now takes ProductData ---
class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onTap,
  });

  final ProductData item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- MODIFIED: DYNAMIC IMAGE ---
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F6),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_,__,___) => const Text('🛒', style: TextStyle(fontSize: 28)),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            // text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name, // Dynamic
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.pricePerUnit, // Dynamic
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price}', // Dynamic (assuming price is just number)
                    style: const TextStyle(
                      color: Color(0xFF4D4D4D),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),
            // --- MODIFIED: DYNAMIC QTY ---
            Obx(() => _QtyPill(value: item.uiQuantity.value, onMinus: onMinus, onPlus: onPlus)),
          ],
        ),
      ),
    );
  }
}


// (All other widgets: _SwipeDeleteBackground, _QtyPill, _GlyphButton, _GlyphPainter, _showDeleteDialog remain unchanged)

// --- UNCHANGED WIDGETS ---

class _SwipeDeleteBackground extends StatelessWidget {
  const _SwipeDeleteBackground();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: _SwipeBgInner(),
    );
  }
}

class _SwipeBgInner extends StatelessWidget {
  const _SwipeBgInner();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          child: Container(
            width: 76,
            color: const Color(0xFFFFEEF0),
            alignment: Alignment.center,
            child: const Icon(Icons.delete_outline, color: Color(0xFFEB5A5A), size: 28),
          ),
        ),
      ],
    );
  }
}

class _QtyPill extends StatelessWidget {
  const _QtyPill({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EAEB),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x14FFFFFF), blurRadius: 24, offset: Offset(0, 16)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GlyphButton(minus: true, onTap: onMinus),
          const SizedBox(width: 8),
          SizedBox(
            width: 18,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF212121),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _GlyphButton(minus: false, onTap: onPlus),
        ],
      ),
    );
  }
}

class _GlyphButton extends StatelessWidget {
  const _GlyphButton({required this.minus, required this.onTap});

  final bool minus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      highlightShape: BoxShape.circle,
      child: SizedBox(
        width: 36,
        height: 36,
        child: CustomPaint(painter: _GlyphPainter(minus: minus)),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter({required this.minus});
  final bool minus;

  static const Color _ink = Color(0xFF33595B);
  static const double _stroke = 2.0;
  static const double _len = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = _stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawLine(Offset(cx - _len / 2, cy), Offset(cx + _len / 2, cy), paint);
    if (!minus) {
      canvas.drawLine(Offset(cx, cy - _len / 2), Offset(cx, cy + _len / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) => oldDelegate.minus != minus;
}