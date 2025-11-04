// lib/features/home/dashboard_screen.dart
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/home/widgets/complete_preference_dialog.dart';

import '../../shell/main_shell_controller.dart';
import '../orders/views/past_order_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _load() async => Future<void>.delayed(const Duration(milliseconds: 1));
  @override
  void initState() { super.initState(); _load(); }
  final shell = Get.find<MainShellController>();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Stack(
        children: [
          // Content below header
          Positioned.fill(
            top: 164,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 425),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ----- Promos -----
                        SizedBox(
                          height: 128,
                          child: PageView(
                            padEnds: false,
                            controller: PageController(viewportFraction: (328 + 12) / w),
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

                        // Last order header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            const Text(
                              'Last order ',
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {
                                shell.goTo(2); // Order tab
                              },
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

                        const _LastOrderCard(),

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
                                  percent: 0.40, // This is the percentage of progress
                                  onEdit: () {
                                    // Close the dialog before navigating to PreferencesScreen
                                    Get.back(); // Close the dialog using GetX

                                    final shell = Get.find<MainShellController>();
                                    shell.openPreferences(); // Navigate to PreferencesScreen
                                  },
                                  onSkip: () {
                                    // Action when 'Skip' button is pressed
                                    Get.back(); // Close the dialog using GetX
                                  },
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

                        // Stats row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: const [
                              Expanded(
                                child: _StatTile(
                                  dotColor: Color(0xFFAA4E2C),
                                  title: 'Total credit',
                                  value: '\$189',
                                ),
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: _StatTile(
                                  dotColor: Color(0xFF89A965),
                                  title: 'Last month savings',
                                  value: '\$18',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const _Hairline(),
                        const SizedBox(height: 24),

                        // Monthly statement
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Monthly statement',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF212121))),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _MonthlyStatement(),

                        const _Hairline(),
                        const SizedBox(height: 24),

                        // Analysis
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Analysis',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF212121))),
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
          ),

          // Teal header 92
          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Container(
              height: 92,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFF33595B),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 382),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 2),
                            Text.rich(TextSpan(children: [
                              TextSpan(text: 'Hi,', style: TextStyle(color: Color(0xFFFEFEFE), fontSize: 18)),
                              TextSpan(text: ' '),
                              TextSpan(text: 'Joshep',
                                  style: TextStyle(color: Color(0xFFFEFEFE), fontSize: 18, fontWeight: FontWeight.w700)),
                            ])),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: Color(0xFFE9E9E9), size: 20),
                                SizedBox(width: 8),
                                Text('Savar, Dhaka', style: TextStyle(color: Color(0xFFE9E9E9), fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

class _LastOrderCard extends StatelessWidget {
  const _LastOrderCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFFFEFEFE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PastOrderDetailsScreen(
                ),
              ),
            );
          },child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F6F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Image.asset('assets/images/walmart.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    // left info
                    SizedBox(
                      width: 152,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Walmart',
                              style: TextStyle(
                                  color: Color(0xFF33595B), fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('25 Dec 2024', style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 14)),
                              _Dot(),
                              Text('6:30pm', style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // exact 1px hairline
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: 1,
                      height: 39,
                      color: const Color(0xFFDEE0E0),
                    ),
                    // right price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        _Price(current: '\$400', old: '\$482'),
                        SizedBox(height: 4),
                        SizedBox(
                          width: 77,
                          child: Text('12 items',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Color(0xFF4D4D4D), fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),)
      ),
    );
  }
}

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

