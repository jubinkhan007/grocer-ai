// lib/features/home/dashboard_screen.dart
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/home/widgets/complete_preference_dialog.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart';
import 'package:grocer_ai/features/orders/widgets/orders_widgets.dart' as order_widget; // Import with prefix
import 'package:grocer_ai/app/app_routes.dart';

import '../../shell/main_shell_controller.dart';
import '../orders/views/past_order_details_screen.dart';
import '../shared/teal_app_bar.dart';
import 'home_controller.dart'; // <-- 1. IMPORT

// --- 2. MODIFIED: Converted to GetView<HomeController> ---
class DashboardScreen extends GetView<HomeController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      // --- 3. MODIFIED: AppBar is now dynamic ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20 + 72), // From TealHomeAppBar
        child: Obx(() => TealHomeAppBar(
          name: controller.userName.value,
          location: controller.location.value,
          showDot: controller.hasUnreadNotifications.value,
          onBellTap: () {
            Get.toNamed(Routes.notifications);
          },
        )),
      ),
      // --- END MODIFICATION ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 425),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // gap between teal header and promos (matches Figma)
                  const SizedBox(height: 16),
                  // ----- Promos (remains static) -----
                  SizedBox(
                    height: 128,
                    child: PageView(
                      padEnds: false,
                      controller: PageController(
                        viewportFraction: (328 + 12) / w,
                      ),
                      children: const [
                        _PromoCard(
                          gradient: [Color(0xFFA64825), Color(0xFFC57254)],
                          begin: Alignment(0.99, 0.93),
                          end: Alignment(0.00, 0.03),
                          title: 'Check out our new deals on rice!',
                          subtitle: 'From 15th April, 2024',
                          asset: 'assets/images/veggies.png',
                        ),
                        _PromoCard(
                          gradient: [Color(0xFF002C2E), Color(0xFF33595B)],
                          begin: Alignment(0.99, 0.93),
                          end: Alignment(0.00, 0.03),
                          title: 'Enjoy the special\noffer upto 30%',
                          subtitle: 'From 14th June, 2022',
                          asset: 'assets/images/veggies.png',
                        ),
                        _PromoCard(
                          gradient: [Color(0xFF51643C), Color(0xFF8AAA66)],
                          begin: Alignment(0.99, 0.93),
                          end: Alignment(0.00, 0.03),
                          title: 'Grab a quick deal for just \$15!',
                          subtitle: 'From 11th June, 2024',
                          asset: 'assets/images/veggies.png',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // --- 4. MODIFIED: Last order header ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Text(
                          'Last order',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: controller.onSeeAllOrders, // <-- Use controller
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: Color(0xFF33595B),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 5. MODIFIED: Dynamic Last Order Card ---
                  Obx(() {
                    if (controller.isLoadingLastOrder.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.lastOrder.value == null) {
                      return const Center(child: Text("No last order found."));
                    }
                    // We have an order, pass it to the widget
                    return _LastOrderCard(order: controller.lastOrder.value!);
                  }),
                  const SizedBox(height: 24),

                  // CTA (pill)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          showCompletePreferenceDialog(
                            context: context,
                            percent: 0.40, // TODO: This should be dynamic
                            onEdit: controller.onEditPreferences,
                            onSkip: controller.onSkipPreferences,
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF33595B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Place a new order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const _Hairline(),
                  const SizedBox(height: 24),

                  // --- 6. MODIFIED: Dynamic Stats row ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Obx(() => Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            dotColor: const Color(0xFFAA4E2C),
                            title: 'Total credit',
                            value: '\$${controller.totalCredit.value}',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _StatTile(
                            dotColor: const Color(0xFF89A965),
                            title: 'Last month savings',
                            value: '\$${controller.lastMonthSavings.value}',
                          ),
                        ),
                      ],
                    )),
                  ),
                  // --- END MODIFICATION ---

                  const _Hairline(),
                  const SizedBox(height: 24),

                  // Monthly statement (remains static)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Monthly statement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _MonthlyStatement(),

                  const _Hairline(),
                  const SizedBox(height: 24),

                  // Analysis (remains static)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _AnalysisBlock(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

/* ---------- small widgets ---------- */

// ... (_PromoCard remains unchanged) ...
class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.begin,
    required this.end,
    this.imageFit = BoxFit.cover,
  });

  final List<Color> gradient;
  final Alignment begin;
  final Alignment end;
  final String title;
  final String subtitle;
  final String asset;
  final BoxFit imageFit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 328,
        height: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), // plugin uses 4
          gradient: LinearGradient(begin: begin, end: end, colors: gradient),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1).copyWith(left: 16, right: 16),
          child: Row(
            children: [
              // text
              SizedBox(
                width: 169,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
              // image block
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(asset, fit: imageFit, height: 117),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 7. MODIFIED: _LastOrderCard now takes an Order object ---
class _LastOrderCard extends StatelessWidget {
  const _LastOrderCard({required this.order});
  final Order order;

  // Helper to map API status to OrderStatus enum
  order_widget.OrderStatus _mapStatusEnum(String statusName) {
    switch (statusName.toLowerCase()) {
      case 'on_the_way':
      case 'packed':
      case 'ordered':
      case 'pending':
        return order_widget.OrderStatus.onTheWay;
      case 'completed':
      case 'delivered':
      case 'paid':
        return order_widget.OrderStatus.completed;
      case 'cancelled':
      case 'failed':
      case 'refunded':
        return order_widget.OrderStatus.cancelled;
      default:
        return order_widget.OrderStatus.onTheWay;
    }
  }

  // Helper to get logo asset
  String _getLogoAsset(String? providerName) {
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
    // --- Create dynamic data for the tile ---
    final price = double.tryParse(order.price) ?? 0.0;
    final discount = double.tryParse(order.discount ?? '0.0') ?? 0.0;
    final oldPrice = price + discount;

    final tileData = order_widget.OrderTileData(
      logo: _getLogoAsset(order.provider?.name),
      brand: order.provider?.name ?? 'Unknown Store',
      status: _mapStatusEnum(order.status),
      priceNow: '\$${price.toStringAsFixed(2)}',
      priceOld: '\$${oldPrice.toStringAsFixed(2)}',
      itemsText: '${order.items.length} items',
    );
    // --- End dynamic data ---

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFFFEFEFE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: InkWell(
          onTap: () {
            // TODO: This should go to the "Current Order Details" screen, not "Past"
            // For now, it's disabled or goes to the wrong place.
            Get.to(() => const PastOrderDetailsScreen(), arguments: order.id);
          },
          // --- Use the shared OrderTile widget ---
          child: order_widget.OrderTile(data: tileData),
        ),
      ),
    );
  }
}
// --- END MODIFICATION ---

// ... (Other widgets: _Price, _Dot, _Hairline, _StatTile, _MonthlyStatement, _AnalysisBlock, _LegendColumnDense, _LegendItem, and showCompletePreferenceDialog remain unchanged) ...
class _Price extends StatelessWidget {
  const _Price({required this.current, required this.old});
  final String current;
  final String old;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(current,
            style: const TextStyle(color: Color(0xFF212121), fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        Text(old,
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
            )),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) =>
      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF8AA0A1), shape: BoxShape.circle));
}

class _Hairline extends StatelessWidget {
  const _Hairline();
  @override
  Widget build(BuildContext context) =>
      const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: SizedBox(height: 1, child: ColoredBox(color: Color(0xFFDEE0E0))));
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.dotColor, required this.title, required this.value});
  final Color dotColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EAEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB0BFBF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF4D4D4D), fontSize: 14)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Color(0xFF212121), fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MonthlyStatement extends StatelessWidget {
  const _MonthlyStatement();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EAEB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFB0BFBF), width: 1),
        ),
        child: Column(
          children: [
            const Text('Total Spent', style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 14)),
            const SizedBox(height: 4),
            const Text('\$45,345.90',
                style: TextStyle(color: Color(0xFF33595B), fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const Text.rich(TextSpan(children: [
              TextSpan(text: 'Savings: ', style: TextStyle(color: Color(0xFF212121), fontSize: 14)),
              TextSpan(text: '\$425', style: TextStyle(color: Color(0xFF212121), fontSize: 14, fontWeight: FontWeight.w700)),
              TextSpan(text: ' with GrocerAI', style: TextStyle(color: Color(0xFF212121), fontSize: 14)),
            ]), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: ShapeDecoration(
                color: const Color(0xFF33595B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Wrap(
                spacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Compared to last month', style: TextStyle(color: Color(0xFFFEFEFE), fontSize: 12)),
                  Icon(Icons.arrow_downward, size: 16, color: Color(0xFFFEFEFE)),
                  Text('10%', style: TextStyle(color: Color(0xFFFEFEFE), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisBlock extends StatelessWidget {
  const _AnalysisBlock();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: LayoutBuilder(
        builder: (ctx, c) {
          const gap = 26.0;
          const maxChart = 210.0;
          const minChart = 120.0;
          const minLegend = 150.0;

          double chartSize = maxChart;
          final roomForLegendIfMaxChart = c.maxWidth - gap - maxChart;
          if (roomForLegendIfMaxChart < minLegend) {
            chartSize = (c.maxWidth - gap - minLegend).clamp(minChart, maxChart);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: chartSize * 0.26,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(value: 51, color: const Color(0xFF295457), showTitle: false),
                      PieChartSectionData(value: 22, color: const Color(0xFFBA4012), showTitle: false),
                      PieChartSectionData(value: 17, color: const Color(0xFFC2EF8F), showTitle: false),
                      PieChartSectionData(value: 10, color: const Color(0xFFBABABA), showTitle: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: gap),
              const Expanded(child: _LegendColumnDense()),
            ],
          );
        },
      ),
    );
  }
}

class _LegendColumnDense extends StatelessWidget {
  const _LegendColumnDense();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _LegendItem(color: Color(0xFF295457), label: 'Fruits', right: '51'),
        SizedBox(height: 12),
        _LegendItem(color: Color(0xFFBA4012), label: 'Vegetables', right: '22%'),
        SizedBox(height: 12),
        _LegendItem(color: Color(0xFFC2EF8F), label: 'Dairy', right: '17%'),
        SizedBox(height: 12),
        _LegendItem(color: Color(0xFFBABABA), label: 'Grains', right: '10%'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label, required this.right});
  final Color color;
  final String label;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 20, height: 16,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Color(0xFF212121))),
        ),
        const SizedBox(width: 8),
        Text(right, style: const TextStyle(fontSize: 14, color: Color(0xFF212121), fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// Show it from anywhere (e.g., Dashboard after load)
Future<void> showCompletePreferenceDialog({
  required BuildContext context,
  required double percent,         // 0..1
  required VoidCallback onEdit,    // navigate to Preferences
  required VoidCallback onSkip,    // just dismiss / persist "remind me later"
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'complete-preference',
    barrierColor: Colors.black.withOpacity(0.5), // subtle dim like Figma
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (_, anim, __, ___) {
      final curved = Curves.easeOutCubic.transform(anim.value);
      return Opacity(
        opacity: anim.value,
        child: Transform.scale(
          scale: 0.98 + 0.02 * curved, // tiny pop-in
          child: CompletePreferenceDialog(
            percent: percent,
            onEdit: onEdit,
            onSkip: onSkip,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 180),
  );
}