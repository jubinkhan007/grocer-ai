// lib/features/orders/views/past_order_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/controllers/past_order_details_controller.dart';
import 'package:grocer_ai/features/orders/models/order_data_item_model.dart';
import 'package:grocer_ai/features/orders/models/order_status_model.dart';
import 'package:intl/intl.dart';
import '../../../ui/theme/app_theme.dart';
import '../../offer/views/offer_screen.dart';
import '../bindings/new_order_binding.dart';
import 'new_order_screen.dart';
import 'orders_screen.dart';

// --- MODIFIED: Converted to GetView<PastOrderDetailsController> ---
class PastOrderDetailsScreen extends GetView<PastOrderDetailsController> {
  const PastOrderDetailsScreen({super.key});

  // --- REMOVED StatefulWidget and _loadDetails ---

  // --- HELPER to get status colors ---
  (Color, Color) _getStatusColors(String statusName) {
    switch (statusName.toLowerCase()) {
      case 'completed':
      case 'delivered':
      case 'paid':
        return (const Color(0xFFE2F2E9), const Color(0xFF3E8D5E));
      case 'cancelled':
      case 'failed':
      case 'refunded':
        return (const Color(0xFFF7E4DD), const Color(0xFFBA4012));
      case 'on_the_way':
      case 'packed':
      case 'ordered':
      case 'pending':
      default:
        return (const Color(0xFFFEF1D7), const Color(0xFF956703));
    }
  }

  // --- HELPER to get logo asset ---
  String _getLogoAsset(String? providerName) {
    switch (providerName?.toLowerCase()) {
      case 'walmart':
        return 'assets/images/walmart.png';
      case 'kroger':
        return 'assets/images/kroger.png';
      case 'aldi':
        return 'assets/images/aldi.png';
    // ... add other cases as needed
      default:
        return 'assets/images/store.png'; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusH = MediaQuery.of(context).padding.top;
    final padTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg, // #F4F6F6
      // --- MODIFIED: Bottom button is now inside the Obx ---
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.order.value == null) {
          return const SizedBox.shrink();
        }
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const NewOrderScreen(), binding: NewOrderBinding());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33595B),
                  foregroundColor: const Color(0xFFFEFEFE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 0,
                ),
                child: const Text('Reorder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        );
      }),
      body: CustomScrollView(
        slivers: [
          /// Figma status bar strip (#002C2E)
          SliverToBoxAdapter(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light, // white status icons
              child: Container(
                height: statusH,
                color: const Color(0xFF33595B), // same teal as app bar
              ),
            ),
          ),
          /// Top bar (teal) exactly like figma
          SliverPersistentHeader(
            pinned: true,
            delegate: _FigmaTealHeader(
              padTop: 0,
              toolbarHeight: 74,
            ),
          ),

          /// --- MODIFIED: WRAP CONTENT IN Obx ---
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final order = controller.order.value;
            if (order == null) {
              return const SliverFillRemaining(
                child: Center(child: Text('Order not found.')),
              );
            }

            // --- Calculate dynamic values ---
            final price = double.tryParse(order.price) ?? 0.0;
            final discount = double.tryParse(order.discount ?? '0.0') ?? 0.0;
            final redeemed = double.tryParse(order.redeemFromWallet ?? '0.0') ?? 0.0;
            final oldPrice = price + discount + redeemed; // Original full price
            final orderValue = price + redeemed; // Price before redemption
            final (statusBg, statusFg) = _getStatusColors(order.status);
            final statusName = order.status.capitalizeFirst ?? 'Unknown';

            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Order ID / Order date (dynamic)
                    _KVRow(label: 'Order ID:', value: order.orderId),
                    const SizedBox(height: 10),
                    _KVRow(
                      label: 'Order date:',
                      value: DateFormat('dd MMM yyyy').format(order.createdAt),
                    ),
                    const SizedBox(height: 24),

                    /// Walmart card (dynamic)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEFEFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6F6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.asset(
                                _getLogoAsset(order.provider?.name),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.store, color: AppColors.teal, size: 24),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.provider?.name ?? 'Unknown Store',
                                          style: const TextStyle(
                                            color: Color(0xFF33595B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: statusBg,
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          child: Text(
                                            statusName,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: statusFg,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(width: 1, height: 39, color: const Color(0xFFDEE0E0)),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _PriceRow(
                                        now: '\$${price.toStringAsFixed(2)}',
                                        old: '\$${oldPrice.toStringAsFixed(2)}',
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 77,
                                        child: Text(
                                          // --- THIS IS THE FIX ---
                                          '${order.items.length} items',
                                          // --- END FIX ---
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Delivery address card (dynamic)
                    _CardBlock(
                      title: 'Delivery address',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Container(height: 1, color: const Color(0xFFE9E9E9)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 20, color: AppColors.subtext),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  order.deliveryAddress,
                                  style: const TextStyle(
                                    color: Color(0xFF212121),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Order summary card (dynamic)
                    _CardBlock(
                      title: 'Order summary',
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          _SumRow(
                            label: 'Order value',
                            sign: '+',
                            amount: '\$${orderValue.toStringAsFixed(2)}',
                            positive: true,
                          ),
                          const SizedBox(height: 12),
                          _SumRow(
                            label: 'Redeemed from balance',
                            sign: '–',
                            amount: '\$${redeemed.toStringAsFixed(2)}',
                            positive: false,
                          ),
                          const SizedBox(height: 12),
                          _SumRow(
                            label: 'Due today',
                            sign: '+',
                            amount: '\$${price.toStringAsFixed(2)}',
                            positive: true,
                          ),
                          const SizedBox(height: 12),
                          const _ThinDivider(),
                          const SizedBox(height: 12),
                          _TotalRow(total: '\$${oldPrice.toStringAsFixed(2)}'), // Total
                        ],
                      ),
                    ),

                    // --- NEW: DYNAMIC ORDER LIST ---
                    const SizedBox(height: 24),
                    const Text(
                      'Items in this order',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return _ItemCard(item: item);
                      },
                    ),
                    // --- END NEW LIST ---

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// --- NEW WIDGET to display an OrderDataItem ---
class _ItemCard extends StatelessWidget {
  final OrderDataItem item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Placeholder icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.shopping_basket_outlined, color: kTeal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.unitPrice,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Quantity
          Text(
            'Qty: ${item.quantity.toInt()}',
            style: const TextStyle(
              color: Color(0xFF4D4D4D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== Helpers that mirror figma text sizes/weights =====

class _KVRow extends StatelessWidget {
  const _KVRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4D4D4D),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.now, required this.old});
  final String now;
  final String old;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          now,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          old,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 16,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}

class _CardBlock extends StatelessWidget {
  const _CardBlock({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFEFEFE), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFE9E9E9));
  }
}

class _SumRow extends StatelessWidget {
  const _SumRow({
    required this.label,
    required this.sign,
    required this.amount,
    required this.positive,
  });

  final String label;
  final String sign; // + | –
  final String amount;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final Color signColor = positive ? const Color(0xFF33595B) : const Color(0xFFBA4012);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Row(
          children: [
            Text(sign, style: TextStyle(color: signColor, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(width: 16),
            Text(amount, style: TextStyle(color: signColor, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

// --- MODIFIED: Now takes a dynamic total ---
class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.total});
  final String total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Total',
            style: TextStyle(
              color: Color(0xFF4D4D4D),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          total,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FigmaTealHeader extends SliverPersistentHeaderDelegate {
  _FigmaTealHeader({
    required this.padTop,
    required this.toolbarHeight,
  });

  final double padTop;          // from MediaQuery
  final double toolbarHeight;   // 56

  static const _teal = Color(0xFF33595B);

  @override
  double get minExtent => padTop + toolbarHeight;
  @override
  double get maxExtent => padTop + toolbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // white status icons on teal
      child: Material(
        color: _teal,
        child: Padding(
          // top padding covers the status area; the visible toolbar remains 56
          padding: EdgeInsets.only(top: padTop),
          child: SizedBox(
            height: toolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFEFEFE), size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 0),
                  const Text(
                    'Order details',
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FigmaTealHeader old) =>
      old.padTop != padTop || old.toolbarHeight != toolbarHeight;
}