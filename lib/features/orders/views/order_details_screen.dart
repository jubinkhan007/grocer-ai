import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';
import 'order_tracking_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // set to your bottom-nav index (Order)
  int _tab = 2;

  // 🔌 API stub – replace with real call later
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
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.teal,
            elevation: 0,
            collapsedHeight: 72,
            titleSpacing: 0,
            title: Container(
              color: AppColors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: const [
                    BackButton(color: Colors.white),
                    SizedBox(width: 4),
                    Text('Order details',
                        style: TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order id / date (two columns)
                  Row(
                    children: const [
                      Expanded(
                        child: _LabeledValue(label: 'Order ID:', value: '#5677654'),
                      ),
                      Expanded(
                        child: _LabeledValue(
                          label: 'Order date:',
                          value: '25 Dec 2024',
                          alignEnd: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Store mini-card
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/brands/walmart.png',
                            width: 24, height: 24,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.storefront_rounded, color: AppColors.teal),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Walmart',
                                  style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.text,
                                  )),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF2CC),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text('On the way',
                                    style: TextStyle(
                                      color: Color(0xFF9A7D1E), fontWeight: FontWeight.w700, fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 38, color: AppColors.divider),
                        const SizedBox(width: 12),
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
                  ),
                  const SizedBox(height: 16),

                  const Text('Order will be delivered at 4:45pm',
                      style: TextStyle(color: AppColors.text, fontSize: 14)),
                  const SizedBox(height: 16),

                  // Address card
                  _CardBlock(
                    title: 'Delivery address',
                    child: Row(
                      children: const [
                        Icon(Icons.location_on_outlined, color: AppColors.subtext),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '1234 Maple Street, Springfield, IL 62704, USA',
                            style: TextStyle(color: AppColors.text, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order summary
                  _CardBlock(
                    title: 'Order summary',
                    contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Column(
                      children: const [
                        _SummaryRow(label: 'Order value', value: '+  \$189', positive: true),
                        _SummaryRow(label: 'Redeemed from balance', value: '–  \$15', positive: false),
                        _SummaryRow(label: 'Due today', value: '+  \$174', positive: true),
                        Divider(height: 22),
                        _SummaryRow(label: 'Total', value: '\$540', bold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CTA
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => const OrderTrackingScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Track order',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FFBottomNav(currentIndex: _tab, onTap: (i) => setState(() => _tab = i)),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value, this.alignEnd = false});
  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.subtext, fontSize: 13)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
      ],
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
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.text, fontSize: 16)),
        const SizedBox(width: 6),
        Text(old,
            style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppColors.subtext)),
      ],
    );
  }
}

class _CardBlock extends StatelessWidget {
  const _CardBlock({required this.title, required this.child, this.contentPadding});
  final String title;
  final Widget child;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
          const Divider(height: 1),
          Padding(
            padding: contentPadding ?? const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.positive,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool? positive; // null for neutral (total)
  final bool bold;

  @override
  Widget build(BuildContext context) {
    Color valColor;
    if (positive == null) {
      valColor = AppColors.text;
    } else {
      valColor = positive! ? AppColors.text : AppColors.danger;
    }
    final fw = bold ? FontWeight.w800 : FontWeight.w600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.subtext))),
          Text(value, style: TextStyle(color: valColor, fontWeight: fw)),
        ],
      ),
    );
  }
}
