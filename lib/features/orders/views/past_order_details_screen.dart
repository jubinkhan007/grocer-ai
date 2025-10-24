import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/views/store_order_screen.dart';
import '../../../ui/theme/app_theme.dart';
import 'new_order_screen.dart';

class PastOrderDetailsScreen extends StatefulWidget {
  const PastOrderDetailsScreen({super.key});

  @override
  State<PastOrderDetailsScreen> createState() => _PastOrderDetailsScreenState();
}

class _PastOrderDetailsScreenState extends State<PastOrderDetailsScreen> {
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
      backgroundColor: AppColors.bg, // #F4F6F6
      body: CustomScrollView(
        slivers: [
          /// Top bar (teal) exactly like figma
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.teal,
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
                    Text(
                      'Order details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // figma title 20
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Content
          SliverToBoxAdapter(
            child: Padding(
              // Figma blocks sit at 24 horizontal spacing
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Order ID / Order date
                  Row(
                    children: const [
                      Expanded(child: _KV(label: 'Order ID:', value: '#5677654')),
                      Expanded(child: _KV(label: 'Order date:', value: '25 Dec 2024', alignEnd: true)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// Walmart card (radius 8, paddings 16/12, exact typography)
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
                              'assets/images/walmart.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.store, color: AppColors.teal, size: 24),
                            ),
                          ),
                          const SizedBox(width: 16),

                          /// Title + badge
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Walmart',
                                        style: TextStyle(
                                          color: Color(0xFF33595B),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE2F2E9),
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: const Text(
                                          'Completed',
                                          style: TextStyle(
                                            color: Color(0xFF3E8D5E),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Vertical divider (39 height)
                                Container(
                                  width: 1,
                                  height: 39,
                                  color: const Color(0xFFDEE0E0),
                                ),
                                const SizedBox(width: 16),

                                /// Prices + items
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    _PriceRow(now: '\$400', old: '\$482'),
                                    SizedBox(height: 4),
                                    SizedBox(
                                      width: 77,
                                      child: Text(
                                        '12 items',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
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

                  /// Delivery address card
                  _CardBlock(
                    title: 'Delivery address',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Container(height: 1, color: const Color(0xFFE9E9E9)),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Icon(Icons.location_on_outlined, size: 20, color: AppColors.subtext),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '1234 Maple Street, Springfield, IL 62704, USA',
                                style: TextStyle(
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

                  /// Order summary card
                  _CardBlock(
                    title: 'Order summary',
                    child: Column(
                      children: const [
                        SizedBox(height: 12),
                        _SumRow(label: 'Order value', sign: '+', amount: '\$189', positive: true),
                        SizedBox(height: 12),
                        _SumRow(label: 'Redeemed from balance', sign: '–', amount: '\$15', positive: false),
                        SizedBox(height: 12),
                        _SumRow(label: 'Due today', sign: '+', amount: '\$174', positive: true),
                        SizedBox(height: 12),
                        _ThinDivider(),
                        SizedBox(height: 12),
                        _TotalRow(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),

      /// Bottom pill button (height 56, radius 100, text 16 semibold)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // GetX (your project already uses Get)
                Get.to(() => const NewOrderScreen());

                // If you prefer Navigator instead, use this and remove the Get line:
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (_) => const NewOrderScreen()),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33595B),
                foregroundColor: const Color(0xFFFEFEFE),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                elevation: 0,
              ),
              child: const Text(
                'Reorder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          ),
        ),
      ),
    );
  }
}

/// ===== Helpers that mirror figma text sizes/weights =====

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
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4D4D4D),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
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
            Text(
              sign,
              style: TextStyle(
                color: signColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              amount,
              style: TextStyle(
                color: signColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
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
          ' \$540',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
