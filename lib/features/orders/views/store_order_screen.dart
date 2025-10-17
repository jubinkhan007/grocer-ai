// lib/features/order/store_order_screen.dart
import 'package:flutter/material.dart';
import 'package:grocer_ai/features/orders/views/store_add_item_screen.dart';

import '../../../ui/theme/app_theme.dart';

class StoreOrderScreen extends StatefulWidget {
  const StoreOrderScreen({
    super.key,
    this.storeName = 'Walmart',
    this.currentTotal = '\$400',
    this.oldTotal = '\$482',
  });

  final String storeName;
  final String currentTotal;
  final String oldTotal;

  @override
  State<StoreOrderScreen> createState() => _StoreOrderScreenState();
}

class _StoreOrderScreenState extends State<StoreOrderScreen> {
  final items = <_OrderItem>[
    _OrderItem('Royal Basmati Rice', '₹8.75/kg', '\$26.25', emoji: '🍚', qty: 3),
    _OrderItem('Sunny Valley Olive Oil', '\$75.30/litter', '\$23.8', emoji: '🫙', qty: 3),
    _OrderItem('Golden Harvest Quinoa', '\$4.29/kg', '\$42.7', emoji: '🧺', qty: 3),
    _OrderItem('Maple Grove Honey', '\$12.50/kg', '\$34.7', emoji: '🍯', qty: 3),
    _OrderItem('Emerald Isle Sea Salt', '\$5.50/kg', '\$28.3', emoji: '🧂', qty: 3),
    _OrderItem('Crisp Apple Juice', '\$3.49/litter', '\$31.4', emoji: '🧃', qty: 3),
    _OrderItem('Mountain Coffee Beans', '\$18.00/kg', '\$29.9', emoji: '☕️', qty: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.teal,
                collapsedHeight: 72,
                titleSpacing: 0,
                title: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const BackButton(color: Colors.white),
                        const SizedBox(width: 4),
                        // Store “logo” + name (simple mark that matches mock spacing)
                        const Icon(Icons.star, color: Colors.amber, size: 26),
                        const SizedBox(width: 8),
                        Text(widget.storeName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            )),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const StoreAddItemScreen()),
                            );
                            // If you're using GetX routing:
                            // Get.to(() => const StoreAddItemScreen());
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add item',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                          style: TextButton.styleFrom(foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
              ),

              // Total pill row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      const Text('Order',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.text)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F6C67).withOpacity(.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('${items.length}',
                            style: const TextStyle(
                                color: AppColors.teal, fontWeight: FontWeight.w700)),
                      ),
                      const Spacer(),
                      _totalPill(widget.currentTotal, widget.oldTotal),
                    ],
                  ),
                ),
              ),

              // Items
              SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, i) => _OrderRow(
                  item: items[i],
                  onMinus: () => setState(() {
                    if (items[i].qty > 0) items[i] = items[i].copyWith(qty: items[i].qty - 1);
                  }),
                  onPlus: () => setState(() {
                    items[i] = items[i].copyWith(qty: items[i].qty + 1);
                  }),
                ),
              ),

              // padding so the floating button doesn’t overlap last row
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // Compare Grocers button
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.12),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    // TODO: compare flow
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  child: const Text(
                    'Compare Grocers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalPill(String now, String old) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6C67).withOpacity(.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Text(now,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.teal, fontSize: 16)),
          const SizedBox(width: 8),
          Text(old,
              style: const TextStyle(
                color: AppColors.teal,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2,
              )),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _emojiTile(item.emoji ?? '🛒'),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
                  const SizedBox(height: 6),
                  Text(item.unit, style: const TextStyle(color: AppColors.subtext, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text(item.price,
                      style: const TextStyle(
                          color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _QtyPill(qty: item.qty, onMinus: onMinus, onPlus: onPlus),
          ],
        ),
      ),
    );
  }

  Widget _emojiTile(String emoji) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 28)),
    );
  }
}

class _QtyPill extends StatelessWidget {
  const _QtyPill({required this.qty, required this.onMinus, required this.onPlus});
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EFEF),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          _circleBtn(Icons.remove, onMinus),
          const SizedBox(width: 12),
          Text('$qty',
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(width: 12),
          _circleBtn(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.text),
      ),
    );
  }
}
