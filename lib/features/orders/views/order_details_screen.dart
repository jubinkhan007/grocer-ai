// lib/features/orders/views/order_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/controllers/order_controller.dart';
import 'package:intl/intl.dart';
import '../../../ui/theme/app_theme.dart';
import 'order_tracking_screen.dart';

// --- MODIFIED: Converted to GetView<OrderController> ---
class OrderDetailsScreen extends GetView<OrderController> {
  const OrderDetailsScreen({super.key});

  // --- ADDED: Helper functions from PastOrderDetailsScreen ---
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

  String _getLogoAsset(String? providerName) {
    switch (providerName?.toLowerCase()) {
      case 'walmart':
        return 'assets/images/walmart.png';
      case 'kroger':
        return 'assets/images/kroger.png';
      case 'aldi':
        return 'assets/images/aldi.png';
      default:
        return 'assets/images/store.png'; // Fallback
    }
  }
  // --- END HELPERS ---

  @override
  Widget build(BuildContext context) {
    final padTop = MediaQuery.of(context).padding.top;
    const _teal = Color(0xFF33595B);
    const _toolbar = 74.0; // Your existing toolbar height

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: CustomScrollView(
        slivers: [
          /// ===== HEADER (unchanged) =====
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: _teal,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            collapsedHeight: _toolbar,
            expandedHeight:  _toolbar,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              color: _teal,
              padding: EdgeInsets.only(top: padTop), // covers the notch only
              child: SizedBox(
                height: _toolbar,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      const BackButton(color: Colors.white),
                      const SizedBox(width: 0),
                      const Text(
                        'Order details',
                        style: TextStyle(
                          color: Color(0xFFFEFEFE),
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// ===== DYNAMIC CONTENT =====
          Obx(() {
            if (controller.isLoadingCurrent.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final order = controller.currentOrder.value;

            if (order == null) {
              return const SliverFillRemaining(
                child: Center(child: Text("No active order found.")),
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

            // Format delivery time
            String deliveryTimeText = 'Your order is on the way';
            if (order.deliveryTime != null) {
              try {
                final dt = DateTime.parse(order.deliveryTime!);
                deliveryTimeText =
                'Order will be delivered at ${DateFormat('h:mm a').format(dt)}';
              } catch (_) {
                deliveryTimeText = 'Order will be delivered soon';
              }
            }

            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ID + Date
                    Row(
                      children: [
                        Expanded(
                          child: _KV(label: 'Order ID:', value: order.orderId),
                        ),
                        Expanded(
                          child: _KV(
                            label: 'Order date:',
                            value: DateFormat('dd MMM yyyy').format(order.createdAt),
                            alignEnd: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    /// Store mini card (radius 16)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEFEFE),
                        borderRadius: BorderRadius.circular(16), // <- exact
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
                              alignment: Alignment.center,
                              child: Image.asset(
                                _getLogoAsset(order.provider?.name),
                                width: 24,
                                height: 24,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.storefront_rounded,
                                  color: AppColors.teal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            /// Brand + status pill
                            Expanded(
                              child: SizedBox(
                                width: 152,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.provider?.name ?? 'Unknown Store',
                                      style: const TextStyle(
                                        color: Color(0xFF33595B),
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusBg,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Text(
                                        statusName,
                                        style: TextStyle(
                                          color: statusFg,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// vertical divider
                            Container(
                              width: 1,
                              height: 39,
                              color: const Color(0xFFDEE0E0),
                            ),
                            const SizedBox(width: 16),

                            /// price + items
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _PriceNowOld(
                                  now: '\$${price.toStringAsFixed(2)}',
                                  old: '\$${oldPrice.toStringAsFixed(2)}',
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 77,
                                  child: Text(
                                    '${order.totalItems} items',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF4D4D4D),
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      deliveryTimeText, // <-- DYNAMIC
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Delivery address
                    _CardBlock(
                      title: 'Delivery address',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _ThinDivider(),
                          const SizedBox(height: 12),
                          _AddressRow(address: order.deliveryAddress), // <-- DYNAMIC
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Order summary
                    _CardBlock(
                      title: 'Order summary',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          _SummaryRow(
                            label: 'Order value',
                            value: '\$${orderValue.toStringAsFixed(2)}',
                            prefix: '+',
                            valueColor: const Color(0xFF33595B),
                          ),
                          const SizedBox(height: 12),
                          _SummaryRow(
                            label: 'Redeemed from balance',
                            value: '\$${redeemed.toStringAsFixed(2)}',
                            prefix: '—',
                            valueColor: const Color(0xFFBA4012),
                          ),
                          const SizedBox(height: 12),
                          _SummaryRow(
                            label: 'Due today',
                            value: '\$${price.toStringAsFixed(2)}',
                            prefix: '+',
                            valueColor: const Color(0xFF33595B),
                          ),
                          const SizedBox(height: 12),
                          const _ThinDivider(),
                          const SizedBox(height: 12),
                          _TotalRow(label: 'Total', total: '\$${oldPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    /// CTA (unchanged)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1915224F), // subtle
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ElevatedButton(
                          onPressed: () =>
                              Get.to(() => const OrderTrackingScreen()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF33595B),
                            foregroundColor: const Color(0xFFFEFEFE),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: const Text(
                            'Track order',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
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

/// ===== Atoms (unchanged metrics except card radius) =====

class _KV extends StatelessWidget {
  const _KV({required this.label, required this.value, this.alignEnd = false});
  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final align =
    alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4D4D4D),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PriceNowOld extends StatelessWidget {
  const _PriceNowOld({required this.now, required this.old});
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
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          old,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
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
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(16), // <- exact
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFE9E9E9),
      width: double.infinity,
    );
  }
}

// --- MODIFIED: Accepts address ---
class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address});
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined,
            size: 20, color: Color(0xFF33595B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address, // <-- DYNAMIC
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.prefix,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String prefix; // '+' or '—'
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$prefix  $value',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.total});
  final String label;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4D4D4D),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          total,
          style: const TextStyle(
            color: Color(0xFF212121),
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}