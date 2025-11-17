// lib/features/orders/widgets/orders_widgets.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/theme/app_theme.dart';

/// ===== Top bar with title + optional range selector =====
class TitleBar extends StatelessWidget {
  const TitleBar({
    required this.showRange,
    required this.rangeText,
    required this.onRangeTap,
  });

  final bool showRange;
  final String rangeText;
  final VoidCallback onRangeTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF33595B),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), // Figma 14x20-ish
            ),
            const SizedBox(width: 8),
            const Text(
              'Order',
              style: TextStyle(
                color: Color(0xFFFEFEFE),
                fontSize: 20,              // Figma
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (showRange)
              InkWell(
                onTap: onRangeTap,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF33595B), // same as bar per plugin
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: const [
                      // Down arrow (16) shown on the left in plugin
                      Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Last 3 months',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFEFEFE),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ===== Segmented Button (exact Figma styles) =====
class SegButton extends StatelessWidget {
  const SegButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16), // plugin
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF33595B) : Colors.transparent, // selected = filled
            borderRadius: BorderRadius.circular(8),
            border: selected
                ? null
                : Border.all(color: const Color(0xFF33595B), width: 1),     // unselected = outline
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selected ? const Color(0xFFE9E9E9) : const Color(0xFF4D4D4D),
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// ===== Current tab content (one card from mock) =====
class CurrentList extends StatelessWidget {
  const CurrentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // plugin shows a little breathing space below the segment
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: const [
          OrderTile(
            data: OrderTileData(
              logo: 'assets/images/walmart.png',
              brand: 'Walmart',
              status: OrderStatus.onTheWay,
              priceNow: '\$400',
              priceOld: '\$482',
              itemsText: '12 items',
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== History group =====
class HistoryGroup extends StatelessWidget {
  const HistoryGroup({
    super.key,
    required this.dateLabel,
    required this.tiles,
  });

  final String dateLabel;
  // --- THIS IS THE FIX ---
  final List<Widget> tiles;
  // --- END FIX ---

  @override
  Widget build(BuildContext context) {
    return Padding(
      // plugin: 24 top to date, 16 to first card
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF001415),
            ),
          ),
          const SizedBox(height: 16),
          // --- THIS IS THE FIX ---
          // Just render the list of widgets directly
          ...tiles,
          // --- END FIX ---
        ],
      ),
    );
  }
}


/// ===== Order tile (used for both screens) =====
enum OrderStatus { onTheWay, completed, cancelled }

class OrderTileData {
  final String logo;
  final String brand;
  final OrderStatus status;
  final String priceNow;
  final String priceOld;
  final String itemsText;

  const OrderTileData({
    required this.logo,
    required this.brand,
    required this.status,
    required this.priceNow,
    required this.priceOld,
    required this.itemsText,
  });
}

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.data});
  final OrderTileData data;

  // Exact badge colors per plugin
  Color get _statusBg {
    switch (data.status) {
      case OrderStatus.onTheWay:
        return const Color(0xFFFEF1D7);
      case OrderStatus.completed:
        return const Color(0xFFE2F2E9);
      case OrderStatus.cancelled:
        return const Color(0xFFF7E4DD);
    }
  }

  Color get _statusFg {
    switch (data.status) {
      case OrderStatus.onTheWay:
        return const Color(0xFF956703);
      case OrderStatus.completed:
        return const Color(0xFF3E8D5E);
      case OrderStatus.cancelled:
        return const Color(0xFFBA4012);
    }
  }

  String get _statusText {
    switch (data.status) {
      case OrderStatus.onTheWay:
        return 'On the way';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // plugin
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(8), // plugin
        // plugin cards appear flat (keep shadow off)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo square
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F6),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              data.logo,
              width: 24,
              height: 24,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.storefront_rounded, color: Color(0xFF33595B)),
            ),
          ),
          const SizedBox(width: 16),

          // Brand + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.brand.replaceAll(RegExp(r'\s+'), ' ').trim(),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF33595B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    _statusText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _statusFg,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 39, // plugin
            color: const Color(0xFFDEE0E0),
          ),

          // Price + items
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    data.priceNow,
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4), // plugin
                  Text(
                    data.priceOld,
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4), // plugin
              SizedBox(
                width: 77, // plugin width cap (visual)
                child: Text(
                  data.itemsText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF4D4D4D),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}