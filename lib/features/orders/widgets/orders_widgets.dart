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
      color: AppColors.teal,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            ),
            const SizedBox(width: 4),
            const Text(
              'Order',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            if (showRange)
              InkWell(
                onTap: onRangeTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        rangeText,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
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

/// ===== Segmented Button =====
class SegButton extends StatelessWidget {
  const SegButton({
    required this.text,
    required this.selected,
    required this.onTap,
    this.filled = false,
  });

  final String text;
  final bool selected;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = filled
        ? AppColors.teal.withOpacity(selected ? 1 : 0.12)
        : (selected ? AppColors.teal : Colors.transparent);

    final border = filled
        ? Border.all(color: AppColors.teal, width: 1.2)
        : Border.all(color: selected ? Colors.transparent : AppColors.teal, width: 1.2);

    final fg = filled
        ? (selected ? Colors.white : AppColors.text.withOpacity(.55))
        : (selected ? Colors.white : AppColors.text.withOpacity(.55));

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: border,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// ===== Current tab content (one card from mock) =====
class CurrentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: const [
          OrderTile(
            data: OrderTileData(
              logo: 'assets/brands/walmart.png',
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
  const HistoryGroup({super.key,
    required this.dateLabel,
    required this.tiles,
  });

  final String dateLabel;
  final List<OrderTileData> tiles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateLabel,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          ...tiles.map((t) => OrderTile(data: t)).toList(),
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
  const OrderTile({required this.data});
  final OrderTileData data;

  Color get statusBg {
    switch (data.status) {
      case OrderStatus.onTheWay:
        return const Color(0xFFFFF2CC); // pale yellow
      case OrderStatus.completed:
        return const Color(0xFFE5F4EA); // pale green
      case OrderStatus.cancelled:
        return const Color(0xFFFCE3DF); // pale red
    }
  }

  Color get _statusFg {
    switch (data.status) {
      case OrderStatus.onTheWay:
        return const Color(0xFF9A7D1E);
      case OrderStatus.completed:
        return const Color(0xFF2E7D32);
      case OrderStatus.cancelled:
        return const Color(0xFFD84343);
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // logo
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              data.logo,
              width: 30,
              height: 30,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.storefront_rounded, color: AppColors.teal),
            ),
          ),
          const SizedBox(width: 14),

          // name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.brand,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    )),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(_statusText,
                      style: TextStyle(
                        color: _statusFg,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ),
          ),

          // divider
          Container(width: 1, height: 44, color: AppColors.divider),

          // price + items
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(data.priceNow,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      )),
                  const SizedBox(width: 8),
                  Text(
                    data.priceOld,
                    style: const TextStyle(
                      color: AppColors.subtext,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                data.itemsText,
                style: const TextStyle(color: AppColors.subtext, fontSize: 15),
              ),
            ],
          )
        ],
      ),
    );
  }
}
