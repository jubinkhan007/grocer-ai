import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import 'order_tracking_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Future<void> _loadDetails() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: CustomScrollView(
        slivers: [
          /// ===== HEADER (exact like mock) =====
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF33595B),
            collapsedHeight: 88,            // <- exact
            toolbarHeight: 88,              // <- exact
            titleSpacing: 0,
            title: Container(
              color: const Color(0xFF33595B),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                      onPressed: Get.back,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFFFEFEFE),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
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

          /// ===== CONTENT =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ID + Date
                  Row(
                    children: const [
                      Expanded(
                        child: _KV(label: 'Order ID:', value: '#5677654'),
                      ),
                      Expanded(
                        child: _KV(
                          label: 'Order date:',
                          value: '25 Dec 2024',
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
                              'assets/brands/walmart.png',
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
                                  const Text(
                                    'Walmart',
                                    style: TextStyle(
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
                                      color: const Color(0xFFFEF1D7),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: const Text(
                                      'On the way',
                                      style: TextStyle(
                                        color: Color(0xFF956703),
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

                          /// vertical divider (39px, #DEE0E0)
                          Container(
                            width: 1,
                            height: 39,
                            color: const Color(0xFFDEE0E0),
                          ),
                          const SizedBox(width: 16),

                          /// price + items
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              _PriceNowOld(now: '\$400', old: '\$482'),
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

                  const Text(
                    'Order will be delivered at 4:45pm',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Delivery address (radius 16)
                  _CardBlock(
                    title: 'Delivery address',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _ThinDivider(),
                        SizedBox(height: 12),
                        _AddressRow(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Order summary (radius 16)
                  _CardBlock(
                    title: 'Order summary',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 4),
                        _SummaryRow(
                          label: 'Order value',
                          value: '\$189',
                          prefix: '+',
                          valueColor: Color(0xFF33595B),
                        ),
                        SizedBox(height: 12),
                        _SummaryRow(
                          label: 'Redeemed from balance',
                          value: '\$15',
                          prefix: '—',
                          valueColor: Color(0xFFBA4012),
                        ),
                        SizedBox(height: 12),
                        _SummaryRow(
                          label: 'Due today',
                          value: '\$174',
                          prefix: '+',
                          valueColor: Color(0xFF33595B),
                        ),
                        SizedBox(height: 12),
                        _ThinDivider(),
                        SizedBox(height: 12),
                        _TotalRow(label: 'Total', total: '\$540'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// CTA (pill + soft shadow like mock)
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
          ),
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

class _AddressRow extends StatelessWidget {
  const _AddressRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.location_on_outlined,
            size: 20, color: Color(0xFF33595B)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            '1234 Maple Street, Springfield, IL 62704, USA',
            style: TextStyle(
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
