// lib/features/orders/views/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/bindings/past_order_details_binding.dart'; // <-- 1. IMPORT
import 'package:grocer_ai/features/orders/models/order_list_model.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart';
import 'package:grocer_ai/features/orders/views/past_order_details_screen.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';
import '../controllers/order_controller.dart';
import '../widgets/orders_widgets.dart';
import 'order_details_screen.dart';

const kTeal = Color(0xFF33595B);

class OrderScreen extends GetView<OrderController> {
  const OrderScreen({super.key});

  void _goToDetails() => Get.to(() => const OrderDetailsScreen());

  // --- 2. MODIFIED: This now takes an ID ---
  void _goToPastDetails(int orderId) {
    Get.to(
          () => const PastOrderDetailsScreen(),
      binding: PastOrderDetailsBinding(orderId: orderId), // <-- 3. Pass ID
    );
  }

  OrderStatus _mapStatusEnum(String statusName) {
    // ... (helper function is unchanged)
    switch (statusName.toLowerCase()) {
      case 'on_the_way':
      case 'packed':
      case 'ordered':
      case 'pending':
        return OrderStatus.onTheWay;
      case 'completed':
      case 'delivered':
      case 'paid':
        return OrderStatus.completed;
      case 'cancelled':
      case 'failed':
      case 'refunded':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.onTheWay;
    }
  }

  String _getLogoAsset(String? providerName) {
    // ... (helper function is unchanged)
    switch (providerName?.toLowerCase()) {
      case 'walmart':
        return 'assets/images/walmart.png';
      case 'kroger':
        return 'assets/images/kroger.png';
      case 'aldi':
        return 'assets/images/aldi.png';
      case 'fred myers':
        return 'assets/images/fred_meyer.png';
      case 'united supermarkets':
        return 'assets/images/united_supermarket.png';
      default:
        return 'assets/images/store.png'; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (build method UI is unchanged up to the history list) ...

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6), // Figma bg
      body: CustomScrollView(
        slivers: [
          // ... (status bar, header, and segmented control are unchanged) ...
          SliverToBoxAdapter(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light, // white status icons
              child: Container(
                height: MediaQuery.of(context).padding.top,
                color: kTeal,
              ),
            ),
          ),
          Obx(() => SliverPersistentHeader(
            pinned: true,
            delegate: _OrderHeader(
              height: 64,
              title: 'Order',
              showRange: controller.segIndex.value == 1,
              rangeText: controller.historyRange.value,
              onPickRange: (picked) {
                if (picked != null) {
                  controller.setHistoryRange(picked);
                }
              },
            ),
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Obx(() => Row(
                children: [
                  SegButton(
                    text: 'Current',
                    selected: controller.segIndex.value == 0,
                    onTap: () => controller.switchSeg(0),
                  ),
                  const SizedBox(width: 16),
                  SegButton(
                    text: 'History',
                    selected: controller.segIndex.value == 1,
                    onTap: () => controller.switchSeg(1),
                  ),
                ],
              )),
            ),
          ),

          Obx(() {
            final index = controller.segIndex.value;

            // --- CURRENT TAB (Index 0) ---
            if (index == 0) {
              if (controller.isLoadingCurrent.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final order = controller.currentOrder.value;
              if (order == null) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No active orders.')),
                );
              }

              final price = double.tryParse(order.price) ?? 0.0;
              final discount = double.tryParse(order.discount ?? '0.0') ?? 0.0;
              final oldPrice = price + discount;

              final tileData = OrderTileData(
                logo: _getLogoAsset(order.provider?.name),
                brand: order.provider?.name ?? 'Unknown Store',
                status: _mapStatusEnum(order.status),
                priceNow: '\$${price.toStringAsFixed(2)}',
                priceOld: '\$${oldPrice.toStringAsFixed(2)}',
                itemsText: 'View Details',
              );

              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _goToDetails,
                    child: Column(
                      children: [OrderTile(data: tileData)],
                    ),
                  ),
                ),
              );
            }

            // --- HISTORY TAB (Index 1) ---
            else {
              if (controller.isLoadingHistory.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.groupedHistory.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No order history found.')),
                );
              }

              final groupKeys = controller.groupedHistory.keys.toList();

              return SliverList.builder(
                itemCount: groupKeys.length,
                itemBuilder: (context, index) {
                  final dateLabel = groupKeys[index];
                  final items = controller.groupedHistory[dateLabel]!;

                  final tiles = items.map((order) {
                    final price = double.tryParse(order.price) ?? 0.0;
                    final discount = double.tryParse(order.discount ?? '0.0') ?? 0.0;
                    final oldPrice = price + discount;

                    return OrderTileData(
                      logo: _getLogoAsset(order.provider?.name),
                      brand: order.provider?.name ?? 'Unknown Store',
                      status: _mapStatusEnum(order.status.name),
                      priceNow: '\$${price.toStringAsFixed(2)}',
                      priceOld: '\$${oldPrice.toStringAsFixed(2)}',
                      itemsText: '${order.totalItems} items',
                    );
                  }).toList();

                  // --- 4. MODIFIED: Pass the order ID ---
                  // This gesture now needs to be on each *item*, not the group
                  return HistoryGroup(
                    dateLabel: dateLabel,
                    // Re-wrap tiles in Gestures
                    tiles: items.map((order) {
                      final price = double.tryParse(order.price) ?? 0.0;
                      final discount = double.tryParse(order.discount ?? '0.0') ?? 0.0;
                      final oldPrice = price + discount;

                      final tileData = OrderTileData(
                        logo: _getLogoAsset(order.provider?.name),
                        brand: order.provider?.name ?? 'Unknown Store',
                        status: _mapStatusEnum(order.status.name),
                        priceNow: '\$${price.toStringAsFixed(2)}',
                        priceOld: '\$${oldPrice.toStringAsFixed(2)}',
                        itemsText: '${order.totalItems} items',
                      );

                      return GestureDetector(
                        onTap: () => _goToPastDetails(order.id),
                        child: OrderTile(data: tileData),
                      );
                    }).toList(),
                  );
                },
              );
            }
          }),
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          )
        ],
      ),
    );
  }
}

// ... (_OrderHeader and _RangeDropdownButton remain unchanged) ...
class _OrderHeader extends SliverPersistentHeaderDelegate {
  _OrderHeader({
    required this.height,
    required this.title,
    required this.showRange,
    required this.rangeText,
    required this.onPickRange,
  });

  final double height;
  final String title;
  final bool showRange;
  final String rangeText;
  final ValueChanged<String?> onPickRange;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        color: kTeal,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tight(const Size(40, 40)),
              ),
              const SizedBox(width: 0),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              const Spacer(),
              if (showRange)
                _RangeDropdownButton(
                  text: rangeText,
                  onSelected: onPickRange,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _OrderHeader old) =>
      old.height != height ||
          old.title != title ||
          old.showRange != showRange ||
          old.rangeText != rangeText;
}

class _RangeDropdownButton extends StatefulWidget {
  const _RangeDropdownButton({required this.text, required this.onSelected});
  final String text;
  final ValueChanged<String?> onSelected;

  @override
  State<_RangeDropdownButton> createState() => _RangeDropdownButtonState();
}

class _RangeDropdownButtonState extends State<_RangeDropdownButton> {
  final GlobalKey _btnKey = GlobalKey();

  Future<void> _openMenu() async {
    final box = _btnKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);

    final picked = await showMenu<String>(
      context: context,
      color: const Color(0xFF33595B), // dark teal panel
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      position: RelativeRect.fromLTRB(
        offset.dx + box.size.width - 150, // Align right
        offset.dy + box.size.height + 6, // small gap below
        overlay.size.width,
        0,
      ),
      items: const [
        PopupMenuItem<String>(
          value: 'Last month',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last month',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Last 2 months',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last 2 months',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Last 3 months',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last 3 months',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Last 6 months',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last 6 months',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );

    widget.onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    // Trigger chip (rounded, darker than app bar, white text)
    return GestureDetector(
      key: _btnKey,
      onTap: _openMenu,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2D5153),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                color: Color(0xFFFEFEFE),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFEFEFE), size: 18),
          ],
        ),
      ),
    );
  }
}