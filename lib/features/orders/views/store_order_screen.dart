// lib/features/order/store_order_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/views/store_add_item_screen.dart';
import '../../../ui/theme/app_theme.dart';
import '../../checkout/views/checkout_screen.dart';
import '../widgets/related_items_sheet.dart';
import 'compare_grocers_screen.dart';

class StoreOrderScreen extends StatefulWidget {
  const StoreOrderScreen({
    super.key,
    this.storeName = 'Walmart',
    this.currentTotal = '\$400',
    this.oldTotal = '\$482',
    this.fromCompare = false,
  });

  final String storeName;
  final String currentTotal;
  final String oldTotal;
  final bool fromCompare;

  @override
  State<StoreOrderScreen> createState() => _StoreOrderScreenState();
}



class _StoreOrderScreenState extends State<StoreOrderScreen> {
  final items = <_OrderItem>[
    _OrderItem('Royal Basmati Rice', '\$8.75/kg', '\$26.25', emoji: '🍚', qty: 3),
    _OrderItem('Sunny Valley Olive Oil', '\$75.30/litter', '\$23.8', emoji: '🫙', qty: 3),
    _OrderItem('Golden Harvest Quinoa', '\$4.29/kg', '\$42.7', emoji: '🧺', qty: 3),
    _OrderItem('Maple Grove Honey', '\$12.50/kg', '\$34.7', emoji: '🍯', qty: 3),
    _OrderItem('Emerald Isle Sea Salt', '\$5.50/kg', '\$28.3', emoji: '🧂', qty: 3),
    _OrderItem('Crisp Apple Juice', '\$3.49/litter', '\$31.4', emoji: '🧃', qty: 3),
    _OrderItem('Mountain Coffee Beans', '\$12.99/kg', '\$19.6', emoji: '☕️', qty: 3),
    _OrderItem('Silver Lake Almond Milk', '\$3.50 unit', '\$19.6', emoji: '🥛', qty: 3),
    _OrderItem('Sunrise Organic Oats', '\$5.50 unit', '\$34.5', emoji: '🥣', qty: 3),
  ];

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

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
                // HEADER
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
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                          Image.asset('assets/images/walmart.png', width: 24, height: 24),
                          const SizedBox(width: 8),
                          Text(
                            widget.storeName,
                            style: const TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const StoreAddItemScreen()),
                              );
                            },
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

                // ORDER HEADER
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
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
                            '${items.length}',
                            style: const TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _totalPill(widget.currentTotal, widget.oldTotal),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // LIST (now swipe-to-delete)
                SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Dismissible(
                      key: ValueKey('${item.title}-$i'),
                      direction: DismissDirection.endToStart, // swipe left
                      confirmDismiss: (_) async =>
                      await _showDeleteDialog(context) ?? false,
                      onDismissed: (_) => setState(() => items.removeAt(i)),
                      // trailing pink strip with delete icon, rounded only on the right
                      background: const _SwipeDeleteBackground(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _OrderRow(
                          item: item,
                          onMinus: () => setState(() {
                            if (items[i].qty > 0) {
                              items[i] = items[i].copyWith(qty: items[i].qty - 1);
                            }
                          }),
                          onPlus: () => setState(() {
                            items[i] = items[i].copyWith(qty: items[i].qty + 1);
                          }),
                        ),
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),

          // CTA
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    if (!widget.fromCompare) {
                      // original behavior
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CompareGrocersScreen()),
                      );
                    } else {
                      Get.to(() => const CheckoutScreen());
                    }
                  },
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
                    child: Text(
                      widget.fromCompare ? 'Checkout' : 'Compare Grocers', // ⬅️ NEW
                      style: const TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // $400 $482 pill
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
            now,
            style: const TextStyle(
              color: Color(0xFF33595B),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            old,
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

class _OrderItem {
  final String title;
  final String unit;
  final String price;
  final String? emoji;
  final int qty;
  _OrderItem(this.title, this.unit, this.price, {this.emoji, this.qty = 1});
  _OrderItem copyWith({int? qty}) =>
      _OrderItem(title, unit, price, emoji: emoji, qty: qty ?? this.qty);
}

// ---------- SWIPE BACKGROUND ----------
class _SwipeDeleteBackground extends StatelessWidget {
  const _SwipeDeleteBackground();

  @override
  Widget build(BuildContext context) {
    // mirror card padding so the pink strip hugs the card
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
        const Expanded(child: SizedBox()), // keep left clear
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          child: Container(
            width: 76,
            color: Color(0xFFFFEEF0), // soft pink like the mock
            alignment: Alignment.center,
            child: const Icon(Icons.delete_outline, color: Color(0xFFEB5A5A), size: 28),
          ),
        ),
      ],
    );
  }
}

// ---------- ROW (unchanged) ----------
class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.item,
    required this.onMinus,
    required this.onPlus,
  });

  final _OrderItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // show the pixel-perfect bottom sheet
        showRelatedItemsBottomSheet(
          context,
          items: const [
            RelatedItem('Mediterranean Breeze Olive Oil', '\$75.30/litter', '\$23.8'),
            RelatedItem('Verdant Valley Olive Oil', '\$75.30/litter', '\$23.8'),
            RelatedItem('Golden Fields Olive Oil', '\$75.30/litter', '\$23.8'),
            RelatedItem('Maple Leaf Olive Oil', '\$75.30/litter', '\$23.8'),
            RelatedItem('Emerald Coast Olive Oil', '\$75.30/litter', '\$23.8'),
            RelatedItem('Mountain Peak Olive Oil', '\$75.30/litter', '\$23.8'),
            RelatedItem('Blue Ridge Olive Oil', '\$75.30/litter', '\$23.8'),
          ],
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // emoji tile
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F6),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(item.emoji ?? '🛒', style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),

            // text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
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
                    item.unit,
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.price,
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
            _QtyPill(value: item.qty, onMinus: onMinus, onPlus: onPlus),
          ],
        ),
      ),
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

// ---------- Delete confirmation (matches your design) ----------
Future<bool?> _showDeleteDialog(BuildContext context) {
  const teal = Color(0xFF33595B);
  return showDialog<bool>(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              //decoration: const BoxDecoration(color: Color(0x1F33595B), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Image.asset('assets/icons/delete.png', height: 50, width: 50,),
            ),
            const SizedBox(height: 16),
            const Text('Delete item',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text)),
            const SizedBox(height: 8),
            const Text('Are you sure you want to delete this item?',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.subtext)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: teal, width: 2),
                      foregroundColor: teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Delete',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
