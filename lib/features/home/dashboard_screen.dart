// lib/features/home/dashboard_screen.dart
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // <-- FIX: Import for dashed borders

// <-- FIX: Removed unused import for '../../widgets/ff_bottom_nav.dart';
// We will replace it with a standard BottomNavigationBar.
// import '../../widgets/ff_bottom_nav.dart';

import '../../../ui/theme/app_theme.dart'; // Assuming this file exists

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  // hook for future API
  Future<void> _load() async =>
      Future<void>.delayed(const Duration(milliseconds: 1));
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Stack(
        children: [
          // Content (starts below the teal header)
          Positioned.fill(
            top: 164, // matches plugin: status(≈48) + header(92) + tiny offset
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
                        // ===== PROMOS (Row like plugin; implemented as PageView for smooth swipe) =====
                        SizedBox(
                          height: 128,
                          child: PageView(
                            padEnds: false,
                            controller:
                            PageController(viewportFraction: (328 + 12) / w),
                            children: const [
                              _PromoCard(
                                gradient: [Color(0xFFA64825), Color(0xFFC57254)],
                                title: 'Check out our new deals on rice!',
                                subtitle: 'From 15th April, 2024',
                                asset: 'assets/images/veggies.png',
                              ),
                              _PromoCard(
                                gradient: [Color(0xFF33595B), Color(0xFF002C2E)], // teal -> deep teal like the shot
                                title: 'Enjoy the special\noffer upto 30%',
                                subtitle: 'From 14th June, 2022',
                                asset: 'assets/images/veggies.png', // the produce basket
                              ),
                              _PromoCard(
                                gradient: [Color(0xFF8AAA66), Color(0xFF51643C)],
                                title: 'Grab a quick deal for just \$15!',
                                subtitle: 'From 11th June, 2024',
                                asset: 'assets/images/veggies.png',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),

                        // ===== Last order =====
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: const [
                              Text('Last order ',
                                  style: TextStyle(
                                    color: Color(0xFF212121),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  )),
                              Spacer(),
                              Text('See all',
                                  style: TextStyle(
                                    color: Color(0xFF33595B),
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        const _LastOrderCard(),

                        const SizedBox(height: 24),

                        // CTA
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: SizedBox(
                            height: 56,
                            width:
                            double.infinity, // <-- FIX: Ensure button fills width
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF33595B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  // <-- FIX: Replaced SizedBox with correct icon
                                  Icon(Icons.shopping_cart_outlined,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 10),
                                  Text('Place a new order',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                      )),
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
                            child: Text(
                              'Monthly statement',
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                            child: Text(
                              'Analysis',
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
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
          ),

          // ===== Teal header bar (92) =====
          Positioned(
            top: 48, // plugin draws a fake status bar; actual OS bar sits above
            left: 0,
            right: 0,
            child: Container(
              height: 92,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFF33595B),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430 - 48),
                  child: Row(
                    children: [
                      // Greeting & location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.center, // <-- FIX: Center column content
                          children: const [
                            SizedBox(height: 2),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: 'Hi,',
                                  style: TextStyle(
                                    color: Color(0xFFFEFEFE),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(text: ' '),
                                TextSpan(
                                  text: 'Joshep',
                                  style: TextStyle(
                                    color: Color(0xFFFEFEFE),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                // <-- FIX: Replaced SizedBox with correct icon
                                Icon(Icons.location_on_outlined,
                                    color: Color(0xFFE9E9E9), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Savar, Dhaka',
                                  style: TextStyle(
                                    color: Color(0xFFE9E9E9),
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Bell
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none_rounded,
                              color: Colors.white),
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

      // <-- FIX: Replaced missing FFBottomNav with a standard BottomNavigationBar
      // bottomNavigationBar: FFBottomNav(
      //       currentIndex: _currentIndex,
      //       onTap: _onItemTapped, // Use the new handler function
      //     ),
    );
  }
}

/* ------------------------- small widgets ------------------------- */

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.asset,      // <-- use local asset
    this.imageFit = BoxFit.contain,
  });

  final List<Color> gradient; // e.g. [Color(0xFF33595B), Color(0xFF0F3536)]
  final String title;
  final String subtitle;
  final String asset;
  final BoxFit imageFit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // matches the spacing between cards in the screenshot
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 328,
        height: 128,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // more rounded like Figma
          gradient: LinearGradient(
            // light (top-left) to dark (bottom-right) – same feel as the shot
            begin: const Alignment(-0.8, -0.9),
            end: const Alignment(0.95, 1.0),
            colors: gradient,
          ),
          boxShadow: const [
            // very soft outer shadow
            BoxShadow(color: Color(0x26000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Stack(
          children: [
            // Content (left side)
            Padding(
              // Figma uses ~16px padding
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700, // slightly bolder
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // image block (right side)
                  SizedBox(
                    width: 170, // matches the visual proportions
                    height: 128,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        asset,
                        fit: imageFit,
                        // keep it nicely padded from the right edge like the design
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // subtle vignette under the image to match the darker right end
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      const Color(0xCC000000).withOpacity(0.10),
                      const Color(0xCC000000).withOpacity(0.18),
                    ],
                    stops: const [0.50, 0.82, 1.0],
                  ),
                ),
              ),
            ),
          ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // <-- FIX: Replace this placeholder with an Image.network or Image.asset
              Container(
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F6F6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                // Example:
                child: Image.asset('assets/images/walmart.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Walmart',
                              style: TextStyle(
                                color: Color(0xFF33595B),
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(height: 4),
                          // replace the Row that has date • dot • time
                          Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('25 Dec 2024',
                                  style: TextStyle(
                                      color: Color(0xFF4D4D4D),
                                      fontSize: 14,
                                      fontFamily: 'Roboto')),
                              _Dot(),
                              Text('6:30pm',
                                  style: TextStyle(
                                      color: Color(0xFF4D4D4D),
                                      fontSize: 14,
                                      fontFamily: 'Roboto')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // <-- FIX: Removed the _VDivider and Spacer widgets
                    // const _VDivider(height: 39),
                    // const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        _Price(current: '\$400', old: '\$482'),
                        SizedBox(height: 4),
                        SizedBox(
                          width: 77,
                          child: Text(
                            '12 items',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 14,
                              fontFamily: 'Roboto',
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
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(width: 4),
        Text(old,
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 16,
              fontFamily: 'Roboto',
              decoration: TextDecoration.lineThrough,
            )),
      ],
    );
  }
}

// <-- This widget is no longer used
// class _VDivider extends StatelessWidget {
//   const _VDivider({this.height = 39});
//   final double height;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       width: 1,
//       height: height,
//       color: const Color(0xFFDEE0E0),
//     );
//   }
// }

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) => Container(
    width: 4,
    height: 4,
    decoration:
    const BoxDecoration(color: Color(0xFF8AA0A1), shape: BoxShape.circle),
  );
}

class _Hairline extends StatelessWidget {
  const _Hairline();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    child: Container(height: 1, color: const Color(0xFFDEE0E0)),
  );
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.dotColor, required this.title, required this.value});
  final Color dotColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    // <-- FIX: Replaced direct parameters with the 'options' object
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: const Color(0xFFB0BFBF),
        strokeWidth: 1,
        radius: const Radius.circular(8),
        dashPattern: const [4, 4],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFB0BFBF).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF4D4D4D),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF212121),
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
      // <-- FIX: Replaced direct parameters with the 'options' object
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: const Color(0xFFB0BFBF),
          strokeWidth: 1,
          radius: const Radius.circular(8),
          dashPattern: const [4, 4],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFB0BFBF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Text('Total Spent',
                  style: TextStyle(
                    color: Color(0xFF4D4D4D),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                  )),
              const SizedBox(height: 4),
              const Text('\$45,345.90',
                  style: TextStyle(
                    color: Color(0xFF33595B),
                    fontSize: 32,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 12),
              const Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: 'Savings: ',
                      style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 14,
                          fontFamily: 'Roboto')),
                  TextSpan(
                      text: '\$425',
                      style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: ' with GrocerAI',
                      style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 14,
                          fontFamily: 'Roboto')),
                ]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0xFF33595B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Text(
                      'Compared to last month',
                      style: TextStyle(
                          color: Color(0xFFFEFEFE),
                          fontSize: 12,
                          fontFamily: 'Roboto'),
                    ),
                    Icon(Icons.arrow_downward, size: 16, color: Color(0xFFFEFEFE)),
                    Text('10%',
                        style: TextStyle(
                            color: Color(0xFFFEFEFE),
                            fontSize: 12,
                            fontFamily: 'Roboto')),
                  ],
                ),
              ),
            ],
          ),
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
          const maxChart = 210.0;   // Figma size
          const minChart = 120.0;   // don’t go smaller than this
          const minLegend = 150.0;  // leave at least this much for legend

          // Compute a chart size that keeps everything on one row.
          double chartSize = maxChart;
          final roomForLegendIfMaxChart = c.maxWidth - gap - maxChart;
          if (roomForLegendIfMaxChart < minLegend) {
            chartSize = c.maxWidth - gap - minLegend;
            chartSize = chartSize.clamp(minChart, maxChart);
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
                    centerSpaceRadius: chartSize * 0.26, // keep proportions
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(value: 51, color: Color(0xFF295457), showTitle: false), // Fruits
                      PieChartSectionData(value: 22, color: Color(0xFFBA4012), showTitle: false), // Vegetables
                      PieChartSectionData(value: 17, color: Color(0xFFC2EF8F), showTitle: false), // Dairy
                      PieChartSectionData(value: 10, color: Color(0xFFBABABA), showTitle: false), // Grains
                    ],
                  ),
                ),
              ),
              const SizedBox(width: gap),
              // Legend takes whatever space is left and never overflows
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
      mainAxisSize: MainAxisSize.min,
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
        // Label flexes and ellipsizes so the row never overflows
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
          ),
        ),
        const SizedBox(width: 8),
        Text(right, style: const TextStyle(fontSize: 14, color: Color(0xFF212121), fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// <-- This widget is no longer used
// class _LegendRow extends StatelessWidget {
//   const _LegendRow({required this.label, required this.value});
//   final String label;
//   final String value;
//   @override
//   Widget build(BuildContext context) => Row(
//         children: [
//           Text(label,
//               style: const TextStyle(
//                   color: Color(0xFF212121),
//                   fontSize: 14,
//                   fontFamily: 'Roboto')),
//           const SizedBox(width: 8),
//           Text(value,
//               style: const TextStyle(
//                   color: Color(0xFF212121),
//                   fontSize: 14,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w600)),
//         ],
//       );
// }

class _LegendSwatch extends StatelessWidget {
  const _LegendSwatch(
      {required this.color, required this.label, required this.pct});
  final Color color;
  final String label;
  final String pct;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
          width: 20,
          height: 16,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(label,
          style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontFamily: 'Roboto')),
      const SizedBox(width: 8),
      Text(pct,
          style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600)),
    ],
  );
}

// Assuming AppTheme is defined elsewhere
class AppTheme {
  static final theme = ThemeData.light();
}