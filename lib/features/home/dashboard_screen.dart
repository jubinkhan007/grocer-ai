// lib/features/home/dashboard_screen.dart
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/features/home/widgets/complete_preference_dialog.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart';
import 'package:grocer_ai/features/orders/widgets/orders_widgets.dart' as order_widget;

import '../../shell/main_shell_controller.dart';
import '../orders/controllers/past_order_details_controller.dart';
import '../orders/services/order_service.dart';
import '../orders/views/past_order_details_screen.dart';
import '../shared/teal_app_bar.dart';
import 'home_controller.dart';
import 'models/dashboard_stats_model.dart'; // <-- for LegendData

class DashboardScreen extends GetView<HomeController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20 + 72),
        child: Obx(() => TealHomeAppBar(
          name: controller.userName.value,        // <-- RxString -> String
          location: controller.location.value,    // <-- RxString -> String
          //padding: const EdgeInsets.symmetric(horizontal: 24), // <-- required
          showDot: controller.hasUnreadNotifications.value,
          onBellTap: () => Get.toNamed(Routes.notifications),
        )),
      ),
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
                  const SizedBox(height: 16),

                  // -------------------- PROMOS --------------------
                  SizedBox(
                    height: 128,
                    child: Obx(() {
                      final loading = controller.isLoadingBanners.value;
                      final banners = controller.banners;
                      final pv = PageController(
                        viewportFraction: (328 + 12) / w,
                      );

                      if (loading || banners.isEmpty) {
                        return PageView(
                          padEnds: false,
                          controller: pv,
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
                        );
                      }

                      const gradients = <List<Color>>[
                        [Color(0xFFA64825), Color(0xFFC57254)],
                        [Color(0xFF002C2E), Color(0xFF33595B)],
                        [Color(0xFF51643C), Color(0xFF8AAA66)],
                      ];
                      const begins = [
                        Alignment(0.99, 0.93),
                        Alignment(0.99, 0.93),
                        Alignment(0.99, 0.93),
                      ];
                      const ends = [
                        Alignment(0.00, 0.03),
                        Alignment(0.00, 0.03),
                        Alignment(0.00, 0.03),
                      ];

                      return PageView.builder(
                        padEnds: false,
                        controller: pv,
                        itemCount: banners.length,
                        itemBuilder: (_, i) {
                          final b = banners[i];
                          final gi = i % 3;
                          return _PromoCard(
                            gradient: gradients[gi],
                            begin: begins[gi],
                            end: ends[gi],
                            title: b.title,
                            subtitle: b.subtitle ?? '',
                            asset: 'assets/images/veggies.png',
                            imageUrl: b.image,
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 36),

                  // -------------------- LAST ORDER HEADER --------------------
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
                          onTap: controller.onSeeAllOrders,
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

                  // -------------------- LAST ORDER CARD --------------------
                  Obx(() {
                    if (controller.isLoadingLastOrder.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final o = controller.lastOrder.value;
                    if (o == null) {
                      return const Center(child: Text("No last order found."));
                    }
                    return _LastOrderCard(order: o);
                  }),

                  const SizedBox(height: 24),

                  // -------------------- CTA --------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          controller.maybePromptToCompletePreferences(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF33595B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Place a new order',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const _Hairline(),
                  const SizedBox(height: 24),

                  // -------------------- STATS ROW --------------------
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
                            value: '\$${controller.lastMonthSavings}', // String getter
                          ),
                        ),
                      ],
                    )),
                  ),

                  const _Hairline(),
                  const SizedBox(height: 24),

                  // -------------------- MONTHLY STATEMENT --------------------
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
                  Obx(() {
                    final stats = controller.lastMonthStats.value;
                    final spent = stats?.totalSpent.toDouble() ?? 45345.90;
                    final saved = stats?.totalSaved.toDouble() ?? 425.00;
                    final change = stats?.spentChangePercentage;
                    final isDown = (change ?? 0) < 0;
                    final arrow = isDown ? Icons.arrow_downward : Icons.arrow_upward;
                    final pct = change == null ? '10%' : '${change.abs().toStringAsFixed(0)}%';

                    return _MonthlyStatementDynamic(
                      totalSpentText: '\$${spent.toStringAsFixed(2)}',
                      savingsText: '\$${saved.toStringAsFixed(0)}',
                      compareText: 'Compared to last month',
                      arrow: arrow,
                      percentText: pct,
                    );
                  }),

                  const _Hairline(),
                  const SizedBox(height: 24),

                  // -------------------- ANALYSIS --------------------
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
                  Obx(() {
                    final a = controller.analysisStats.value;
                    return _AnalysisBlock(data: a?.asLegendData);
                  }),
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

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.begin,
    required this.end,
    this.imageFit = BoxFit.cover,
    this.imageUrl,
  });

  final List<Color> gradient;
  final Alignment begin;
  final Alignment end;
  final String title;
  final String subtitle;
  final String asset;
  final BoxFit imageFit;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 328,
        height: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(begin: begin, end: end, colors: gradient),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1) // <-- named arg
              .copyWith(left: 16, right: 16),
          child: Row(
            children: [
              // text
              SizedBox(
                width: 169,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // image block
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: (imageUrl != null && imageUrl!.isNotEmpty)
                      ? Image.network(imageUrl!, fit: imageFit, height: 117)
                      : Image.asset(asset, fit: imageFit, height: 117),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Last Order Card (design preserved) ---
class _LastOrderCard extends StatelessWidget {
  const _LastOrderCard({required this.order});
  final Order order;
  String _oneLine(String? s) =>
      (s ?? 'Unknown Store').replaceAll(RegExp(r'\s+'), ' ').trim();


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
        return 'assets/images/store.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(order.price) ?? 0.0;
    final discount = double.tryParse(order.discount ?? '0.0') ?? 0.0;
    final oldPrice = price + discount;

    final tileData = order_widget.OrderTileData(
      logo: _getLogoAsset(order.provider?.name),
      brand: _oneLine(order.provider?.name), // <-- use single-line text
      status: _mapStatusEnum(order.status),
      priceNow: '\$${price.toStringAsFixed(2)}',
      priceOld: '\$${oldPrice.toStringAsFixed(2)}',
      itemsText: '${order.items.length} items',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFFFEFEFE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: InkWell(
          onTap: () {
            final id = (order.id is int) ? order.id as int : int.parse('${order.id}');
            Get.to(
                  () => const PastOrderDetailsScreen(),
              binding: BindingsBuilder(() {
                Get.put(
                  PastOrderDetailsController(Get.find<OrderService>(), orderId: id),
                );
              }),
            );
          },
          child: order_widget.OrderTile(data: tileData),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) => Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(color: Color(0xFF8AA0A1), shape: BoxShape.circle));
}

class _Hairline extends StatelessWidget {
  const _Hairline();
  @override
  Widget build(BuildContext context) => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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

class _MonthlyStatementDynamic extends StatelessWidget {
  const _MonthlyStatementDynamic({
    required this.totalSpentText,
    required this.savingsText,
    required this.compareText,
    required this.arrow,
    required this.percentText,
  });

  final String totalSpentText;
  final String savingsText;
  final String compareText;
  final IconData arrow;
  final String percentText;

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
            Text(totalSpentText,
                style: const TextStyle(color: Color(0xFF33595B), fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: 'Savings: ', style: TextStyle(color: Color(0xFF212121), fontSize: 14)),
                TextSpan(
                    text: savingsText,
                    style: const TextStyle(color: Color(0xFF212121), fontSize: 14, fontWeight: FontWeight.w700)),
                const TextSpan(text: ' with GrocerAI', style: TextStyle(color: Color(0xFF212121), fontSize: 14)),
              ]),
              textAlign: TextAlign.center,
            ),
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
  const _AnalysisBlock({this.data});
  final List<LegendData>? data;

  @override
  Widget build(BuildContext context) {
    final d = data ??
        [
          LegendData(color: const Color(0xFF295457), label: 'Fruits', value: 51),
          LegendData(color: const Color(0xFFBA4012), label: 'Vegetables', value: 22),
          LegendData(color: const Color(0xFFC2EF8F), label: 'Dairy', value: 17),
          LegendData(color: const Color(0xFFBABABA), label: 'Grains', value: 10),
        ];

    final total = d.fold<double>(0, (p, e) => p + e.value);
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
                    sections: d
                        .map((e) => PieChartSectionData(
                      value: e.value,
                      color: e.color,
                      showTitle: false,
                    ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: gap),
              Expanded(child: _LegendColumnDense(data: d, total: total)),
            ],
          );
        },
      ),
    );
  }
}

class _LegendColumnDense extends StatelessWidget {
  const _LegendColumnDense({required this.data, required this.total});
  final List<LegendData> data;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data
          .map((e) {
        final pct = total == 0 ? 0 : (e.value / total) * 100.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _LegendItem(
            color: e.color,
            label: e.label,
            right: '${pct.toStringAsFixed(0)}%',
          ),
        );
      })
          .toList(),
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
        Container(
          width: 20,
          height: 16,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          right,
          style: const TextStyle(fontSize: 14, color: Color(0xFF212121), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// unchanged dialog helper
Future<void> showCompletePreferenceDialog({
  required BuildContext context,
  required double percent,         // 0..1
  required VoidCallback onEdit,
  required VoidCallback onSkip,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'complete-preference',
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (dialogContext, anim, __, ___) {
      final curved = Curves.easeOutCubic.transform(anim.value);
      return Opacity(
        opacity: anim.value,
        child: Transform.scale(
          scale: 0.98 + 0.02 * curved,
          child: CompletePreferenceDialog(
            percent: percent,
            onClose: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
            onSkip: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              onSkip();
            },
            onEdit: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              onEdit();
            },
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 180),
    useRootNavigator: true,
  );
}