import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../../widgets/ff_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tab = 0;

  // 🔌 API hook (keep signature, swap body once endpoint is ready)
  Future<void> _loadDashboard() async {
    // TODO: call your DashboardService here, then setState with data
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.teal,
            elevation: 0,
            pinned: true,
            expandedHeight: 140,
            collapsedHeight: 72,
            flexibleSpace: FlexibleSpaceBar(
              background: _Header(),
              titlePadding: EdgeInsets.zero,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PromoBanner(),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Last order',
                    action: 'See all',
                    onAction: () {}, // TODO: navigate to orders
                  ),
                  const SizedBox(height: 12),
                  _LastOrderCard(),
                  const SizedBox(height: 24),
                  _NewOrderCTA(onPressed: () {
                    // TODO: navigate to new order flow
                  }),
                  const SizedBox(height: 24),
                  _StatsRow(),
                  const SizedBox(height: 24),
                  const Text('Monthly statement',
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      )),
                  const SizedBox(height: 12),
                  _MonthlyCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FFBottomNav(
        currentIndex: _tab,
        onTap: (i) {
          setState(() => _tab = i);
          // TODO: route switch if needed
        },
      ),
    );
  }
}

/// ======== Header (Hi, name + location + bell) ========
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.teal,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row (spacer for status bar area)
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 8),
                      Text(
                        'Hi, Joshep',
                        style: TextStyle(
                          color: Colors.white, fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              color: Colors.white70, size: 18),
                          SizedBox(width: 6),
                          Text('Savar, Dhaka',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {
                        // TODO: open notifications
                      },
                      icon: const Icon(Icons.notifications_none_rounded,
                          color: Colors.white, size: 26),
                    ),
                    Positioned(
                      right: 10, top: 10,
                      child: Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ======== Promo Banner ========
class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF0E5F5A),
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/veggies.jpg'), // optional
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enjoy the special\noffer upto 30%',
                  style: TextStyle(
                      color: Colors.white, fontSize: 22,
                      fontWeight: FontWeight.w800, height: 1.2),
                ),
                SizedBox(height: 8),
                Text('From 14th June, 2022',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ======== Section Header ========
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text)),
        const Spacer(),
        if (action != null)
          InkWell(
            onTap: onAction,
            child: Text(action!,
                style: const TextStyle(
                    color: AppColors.teal,
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

/// ======== Last Order Card ========
class _LastOrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/walmart.png', // fallback to icon if missing
              width: 32, height: 32,
              errorBuilder: (_, __, ___) => const Icon(Icons.storefront_rounded, color: AppColors.teal),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Walmart',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text('25 Dec 2024', style: TextStyle(color: AppColors.subtext)),
                    Text('   •   ', style: TextStyle(color: AppColors.subtext)),
                    Text('6:30pm', style: TextStyle(color: AppColors.subtext)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              _PriceRow(current: '\$400', old: '\$482'),
              SizedBox(height: 6),
              Text('12 items', style: TextStyle(color: AppColors.subtext)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.current, required this.old});
  final String current;
  final String old;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(current,
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.text, fontSize: 18)),
        const SizedBox(width: 6),
        Text(old,
            style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: AppColors.subtext)),
      ],
    );
  }
}

/// ======== CTA Button ========
class _NewOrderCTA extends StatelessWidget {
  const _NewOrderCTA({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Place a new order',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
        ),
      ),
    );
  }
}

/// ======== Stats Row (Dotted cards) ========
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatCard(title: 'Total credit', value: '\$189', dotColor: Colors.brown)),
        SizedBox(width: 16),
        Expanded(child: _StatCard(title: 'Last month savings', value: '\$18', dotColor: Colors.green)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.dotColor});
  final String title;
  final String value;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      // ✅ new API uses an options object
      options: const RoundedRectDottedBorderOptions(
        dashPattern: [6, 6],
        strokeWidth: 1.2,
        radius: Radius.circular(16),
        color: Color(0xFFD4D9DE),
        padding: EdgeInsets.zero,
      ),
      child: Container(
        height: 108,
        decoration: BoxDecoration(
          color: Color(0xFFF1F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 10, height: 10,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      color: AppColors.text, fontWeight: FontWeight.w600)),
            ]),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.text)),
          ],
        ),
      ),
    );
  }
}


/// ======== Monthly Statement Card ========
class _MonthlyCard extends StatelessWidget {
  const _MonthlyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E6EA)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: const [
          Text('Total Spent',
              style: TextStyle(color: AppColors.subtext, fontSize: 16)),
          SizedBox(height: 10),
          Text('\$45,345.90',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.teal)),
          SizedBox(height: 12),
          Text('Savings: \$425 with GrocerAI',
              style: TextStyle(color: AppColors.text, fontSize: 15)),
        ],
      ),
    );
  }
}
