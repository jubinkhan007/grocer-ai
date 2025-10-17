// lib/features/order/views/store_add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import 'models/order_models.dart';

class StoreAddItemScreen extends StatefulWidget {
  const StoreAddItemScreen({super.key});

  @override
  State<StoreAddItemScreen> createState() => _StoreAddItemScreenState();
}

class _StoreAddItemScreenState extends State<StoreAddItemScreen> {
  final TextEditingController _search = TextEditingController();
  final items = mockItems.toList(); // swap with API later
  final Set<int> _markedForDelete = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const BackButton(color: Colors.white),
            const SizedBox(width: 6),
            // Walmart + spark icon
            const _StoreTitle(),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                Get.to(() => relatedItemsSheet.openAsPage());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.add, size: 20, color: Colors.white),
              label: const Text('Add item',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
        children: [
          // Order + total chip
          Container(
            color: AppColors.teal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                const _OrderCountChip(count: 13),
                const Spacer(),
                _TotalChip(current: '\$400', old: '\$482'),
              ],
            ),
          ),

          // Search
          Container(
            height: 44,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 10),
              ),
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final it = items[i];
                if (_search.text.isNotEmpty &&
                    !it.title.toLowerCase().contains(_search.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }

                return _ItemTile(
                  item: it,
                  qty: it.qty,
                  onMinus: () => setState(() => it.qty = (it.qty - 1).clamp(0, 99)),
                  onPlus: () => setState(() => it.qty = (it.qty + 1).clamp(0, 99)),
                  // long-press or trash icon → confirm delete
                  onDelete: () async {
                    final ok = await _showDeleteDialog(context);
                    if (ok == true) {
                      setState(() {
                        _markedForDelete.add(it.id);
                      });
                      await Future.delayed(const Duration(milliseconds: 250));
                      setState(() {
                        items.removeWhere((e) => _markedForDelete.contains(e.id));
                        _markedForDelete.remove(it.id);
                      });
                      _showDeletedSnack();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Bottom pill button
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              // Later: open comparison flow
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: const Text(
              'Compare Grocers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _DialogHeaderIcon(icon: Icons.delete_outline),
              const SizedBox(height: 10),
              const Text('Delete item',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 6),
              const Text('Are you sure you want to delete this item?',
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete'),
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

  void _showDeletedSnack() {
    Get.rawSnackbar(
      backgroundColor: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      messageText: Row(
        children: const [
          _DialogHeaderIcon(icon: Icons.check_circle_outline, color: AppColors.teal),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Item is deleted successfully',
              style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// ======= Widgets =======

class _StoreTitle extends StatelessWidget {
  const _StoreTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.brightness_high, color: Colors.amber, size: 24), // Walmart spark-ish
        SizedBox(width: 8),
        Text('Walmart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            )),
      ],
    );
  }
}

class _OrderCountChip extends StatelessWidget {
  const _OrderCountChip({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Order',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('$count',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({required this.current, required this.old});
  final String current;
  final String old;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Text(current,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(width: 6),
          Text(
            old,
            style: const TextStyle(
              color: Colors.white70,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    required this.onDelete,
  });

  final OrderItem item;
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _IconBadge(emoji: item.emoji),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(item.pricePer,
                      style:
                      const TextStyle(color: AppColors.subtext, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(item.price,
                      style: const TextStyle(
                          color: AppColors.text, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            _QtyPill(
              qty: qty,
              onMinus: onMinus,
              onPlus: onPlus,
              trailingTrash: true,
              onTrash: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.emoji});
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 28)),
    );
  }
}

class _QtyPill extends StatelessWidget {
  const _QtyPill({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    this.trailingTrash = false,
    this.onTrash,
  });

  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool trailingTrash;
  final VoidCallback? onTrash;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0EE),
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              _roundIcon(Icons.remove, onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('$qty',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 18)),
              ),
              _roundIcon(Icons.add, onPlus),
            ],
          ),
        ),
        if (trailingTrash) ...[
          const SizedBox(width: 10),
          InkWell(
            onTap: onTrash,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEF0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: Color(0xFFEB5A5A)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _roundIcon(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, size: 18, color: AppColors.text),
    ),
  );
}

class _DialogHeaderIcon extends StatelessWidget {
  const _DialogHeaderIcon({required this.icon, this.color});
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: (color ?? AppColors.teal).withOpacity(.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color ?? AppColors.teal),
    );
  }
}

/// Related items bottom sheet (full page style for now)
class relatedItemsSheet extends StatelessWidget {
  const relatedItemsSheet();

  static Widget openAsPage() => const relatedItemsSheet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: const [
            Text('Related items',
                style: TextStyle(
                    color: AppColors.text, fontWeight: FontWeight.w700)),
            SizedBox(width: 6),
            _CountBadge(13),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Skip',
                style:
                TextStyle(color: AppColors.subtext, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: related.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final it = related[i];
          return relatedItemTile(item: it);
        },
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge(this.count);
  final int count;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppColors.divider),
    ),
    child: Text('$count',
        style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}

class relatedItemTile extends StatelessWidget {
  const relatedItemTile({required this.item});
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _IconBadge(emoji: item.emoji),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(item.pricePer,
                    style:
                    const TextStyle(fontSize: 13, color: AppColors.subtext)),
                const SizedBox(height: 4),
                Text(item.price,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          _QtyPill(qty: item.qty, onMinus: () {}, onPlus: () {}),
        ],
      ),
    );
  }
}
