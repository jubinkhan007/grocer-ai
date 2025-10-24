// lib/features/order/views/store_add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../models/order_models.dart';

class StoreAddItemScreen extends StatefulWidget {
  const StoreAddItemScreen({super.key});
  @override
  State<StoreAddItemScreen> createState() => _StoreAddItemScreenState();
}

class _StoreAddItemScreenState extends State<StoreAddItemScreen> {
  final TextEditingController _search = TextEditingController();
  final items = mockItems.toList();
  final _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF33595B),
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              BackButton(color: Colors.white),
              SizedBox(width: 8),
              Image.asset("assets/images/walmart.png", width: 24, height: 24,),
              SizedBox(width: 8),
              Text(
                'Walmart',
                style: TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Scrollbar(
        controller: _scroll,
        thickness: 4,
        radius: const Radius.circular(40),
        thumbVisibility: true,
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          children: [
            // SEARCH – capsule r=128 like Figma
            _SearchField(
              controller: _search,
              onCleared: () => setState(_search.clear),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // LIST
            ...items.where((it) {
              final q = _search.text.trim().toLowerCase();
              return q.isEmpty || it.title.toLowerCase().contains(q);
            }).map((it) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ItemTile(
                item: it,
                onMinus: () => setState(() => it.qty = (it.qty - 1).clamp(0, 99)),
                onPlus: () => setState(() => it.qty = (it.qty + 1).clamp(0, 99)),
              ),
            )),
          ],
        ),
      ),

      // Bottom CTA (matches Figma)
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
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
          child: const Text(
            'Add to order list',
            style: TextStyle(
              color: Color(0xFFFEFEFE),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Search capsule identical to plugin output
class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onCleared,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: const Color(0xFFFEFEFE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(128)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF6A6A6A)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              splashRadius: 18,
              onPressed: onCleared,
              icon: const Icon(Icons.close, size: 20, color: Color(0xFF6A6A6A)),
            ),
        ],
      ),
    );
  }
}

/// One item card exactly per Figma
class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.onMinus,
    required this.onPlus,
  });

  final OrderItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Emoji tile 64×64 r=4, bg F4F6F6
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: const Color(0xFFF4F6F6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),

          // Text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
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
                // Unit
                Text(
                  item.pricePer,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                const SizedBox(height: 8),
                // Price
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

          // Qty pill (48h, r=40) with white round +/- buttons
          _QtyPill(            value: item.qty,
            onMinus: onMinus,
            onPlus: onPlus,),
        ],
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
      height: 48,                                     // Figma
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EAEB),              // pill gray
        borderRadius: BorderRadius.circular(24),      // half height => perfect capsule
        boxShadow: const [
          // soft bloom seen in the asset
          BoxShadow(color: Color(0x14FFFFFF), blurRadius: 24, offset: Offset(0, 16)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GlyphButton(minus: true, onTap: onMinus),
          const SizedBox(width: 8),
          SizedBox(
            width: 18,                                 // matches numeric width in comp
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
      radius: 22,                                     // touch target
      highlightShape: BoxShape.circle,
      child: SizedBox(
        width: 36, height: 36,                        // spec’d circles in comp
        child: CustomPaint(
          painter: _GlyphPainter(minus: minus),
        ),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter({required this.minus});
  final bool minus;

  static const Color _ink = Color(0xFF33595B);        // Figma teal
  static const double _stroke = 2.0;                  // thin stroke as in image
  static const double _len = 14;                      // glyph length inside 36 box

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = _stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // minus
    canvas.drawLine(Offset(cx - _len / 2, cy), Offset(cx + _len / 2, cy), paint);

    // plus vertical bar (only for +)
    if (!minus) {
      canvas.drawLine(Offset(cx, cy - _len / 2), Offset(cx, cy + _len / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) => oldDelegate.minus != minus;
}
