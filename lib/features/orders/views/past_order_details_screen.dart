import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';

class PastOrderDetailsScreen extends StatefulWidget {
  const PastOrderDetailsScreen({super.key});

  @override
  State<PastOrderDetailsScreen> createState() => _PastOrderDetailsScreenState();
}

class _PastOrderDetailsScreenState extends State<PastOrderDetailsScreen> {
  // 🔌 API hook – replace with real call once endpoint is ready
  Future<void> _loadDetails() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    // TODO: OrderService.fetchPastOrderDetails(orderId)
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID + Date (two columns)
                  Row(
                    children: const [
                      Expanded(
                        child: _KV(label: 'Order ID:', value: '#5677654'),
                      ),
                      Expanded(
                        child: _KV(label: 'Order date:', value: '25 Dec 2024', alignEnd: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Store card (Completed)
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                            'assets/brands/walmart.png',
                            width: 30, height: 30,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.storefront_rounded, color: AppColors.teal),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Walmart',
                                  style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text,
                                  )),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5F4EA),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text('Completed',
                                    style: TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 44, color: AppColors.divider),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            _PriceRow(now: '\$400', old: '\$482'),
                            SizedBox(height: 6),
                            Text('12 items', style: TextStyle(color: AppColors.subtext)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Delivery address
                  _CardBlock(
                    title: 'Delivery address',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Divider(height: 1),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: AppColors.subtext),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '1234 Maple Street, Springfield, IL 62704, USA',
                                style: TextStyle(color: AppColors.text, fontSize: 16, height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order summary
                  _CardBlock(
                    title: 'Order summary',
                    child: Column(
                      children: const [
                        SizedBox(height: 6),
                        _SumRow(label: 'Order value', sign: '+', amount: '\$189', positive: true),
                        SizedBox(height: 14),
                        _SumRow(label: 'Redeemed from balance', sign: '–', amount: '\$15', positive: false),
                        SizedBox(height: 14),
                        _SumRow(label: 'Due today', sign: '+', amount: '\$174', positive: true),
                        SizedBox(height: 14),
                        Divider(height: 22),
                        _TotalRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Big rounded “Reorder” button (bottom)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: SizedBox(
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                // TODO: OrderService.reorder(orderId)
                Get.snackbar('Reorder', 'This would add items back to cart.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              ),
              child: const Text(
                'Reorder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KV extends StatelessWidget {
  const _KV({required this.label, required this.value, this.alignEnd = false});
  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.subtext, fontSize: 16)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 18)),
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
        Text(now, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.text, fontSize: 18)),
        const SizedBox(width: 6),
        Text(old, style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppColors.subtext)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
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
  final String sign;      // '+' | '–'
  final String amount;    // formatted with currency
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final Color signColor = positive ? AppColors.teal : AppColors.danger;

    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(color: AppColors.subtext, fontSize: 16)),
        ),
        Row(
          children: [
            Text(sign,
                style: TextStyle(
                  color: signColor, fontWeight: FontWeight.w700, fontSize: 22, height: 1,
                )),
            const SizedBox(width: 12),
            Text(amount,
                style: TextStyle(
                  color: signColor, fontWeight: FontWeight.w700, fontSize: 20,
                )),
          ],
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Text('Total',
              style: TextStyle(
                color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 18,
              )),
        ),
        Text('\$540',
            style: TextStyle(
              color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 20,
            )),
      ],
    );
  }
}
