import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';

// ----------------------------- DATA (static for now) -----------------------------
class _SummaryStore {
  final String name;
  final String when;
  final String priceNow;
  final String priceOld;
  final String items;

  const _SummaryStore(this.name, this.when, this.priceNow, this.priceOld, this.items);
}

class _ItemRowData {
  final String emoji;
  final String name;
  final String unit;
  final String price;
  final bool na;

  const _ItemRowData({
    required this.emoji,
    required this.name,
    required this.unit,
    required this.price,
    this.na = false,
  });
}

// Reusable mock items
const _items = <_ItemRowData>[
  _ItemRowData(emoji: '🍚', name: 'Royal Basmati Rice', unit: '\$8.75 unit', price: '\$26.25'),
  _ItemRowData(emoji: '🫙', name: 'Sunny Valley Olive Oil', unit: '\$75.30 unit', price: '\$23.8'),
  _ItemRowData(emoji: '🥕', name: 'Golden Harvest Quinoa', unit: '\$4.29 unit', price: '\$42.7'),
  _ItemRowData(emoji: '🍯', name: 'Maple Grove Honey', unit: '\$12.50 unit', price: '\$34.7'),
  _ItemRowData(emoji: '🧂', name: 'Emerald Isle Sea Salt', unit: '\$5.50 unit', price: '\$28.3'),
  _ItemRowData(emoji: '🧃', name: 'Crisp Apple Juice', unit: '\$3.49 unit', price: '\$31.4'),
  _ItemRowData(emoji: '☕️', name: 'Mountain Coffee Beans', unit: '\$19.99 unit', price: '\$29.9'),
];

// ----------------------------- ENTRY SCREEN -----------------------------
class CompareGrocersScreen extends StatefulWidget {
  const CompareGrocersScreen({super.key});

  @override
  State<CompareGrocersScreen> createState() => _CompareGrocersScreenState();
}

class _CompareGrocersScreenState extends State<CompareGrocersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    // TODO: call compare endpoint here and setState with results
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
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
            collapsedHeight: 72,
            titleSpacing: 0,
            title: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: const [
                    BackButton(color: Colors.white),
                    SizedBox(width: 4),
                    Text('Comparison Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        )),
                    Spacer(),
                    Icon(Icons.refresh, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text('Rebid',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: Container(
                color: AppColors.teal,
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tab,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Comparison Summary'),
                    Tab(text: 'Live Bid Status'),
                  ],
                ),
              ),
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: true,
            child: TabBarView(
              controller: _tab,
              children: const [
                _SummaryTab(),
                _LiveBidTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------- TAB 1: SUMMARY -----------------------------
class _SummaryTab extends StatelessWidget {
  const _SummaryTab();

  @override
  Widget build(BuildContext context) {
    // static list (match mock order)
    const list = <_SummaryStore>[
      _SummaryStore('Walmart', '25 Dec 2024  •  6:30pm', '\$210', '\$250', '15 items'),
      _SummaryStore('Kroger',  '14 Mar 2025  •  3:45pm', '\$350', '\$345', '22 items'),
      _SummaryStore('Aldi',    '7 Aug 2023   •  11:15am', '\$320', '\$360', '19 items'),
      _SummaryStore('Fred Myers', '7 Aug 2023 •  9:45am', '\$350', '\$380', '14 items'),
      _SummaryStore('United Supermarkets', '7 Aug 2023 •  2:30pm', '\$400', '\$420', '12 items'),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemBuilder: (_, i) {
        final s = list[i];
        return _StoreSummaryTile(
          name: s.name,
          when: s.when,
          priceNow: s.priceNow,
          priceOld: s.priceOld,
          items: s.items,
          onTap: () {
            // go to detail compare for this store
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CompareStoreDetailScreen(
                storeName: s.name,
                items: _items,
                totalNow: '\$400',
                totalOld: '\$482',
                showNAForSome: s.name == 'Kroger', // to match the 4th mock
              ),
            ));
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: list.length,
    );
  }
}

class _StoreSummaryTile extends StatelessWidget {
  const _StoreSummaryTile({
    required this.name,
    required this.when,
    required this.priceNow,
    required this.priceOld,
    required this.items,
    required this.onTap,
  });

  final String name, when, priceNow, priceOld, items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _logoBubble(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
                  const SizedBox(height: 4),
                  Text(when, style: const TextStyle(color: AppColors.subtext)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(priceNow,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: AppColors.text)),
                    const SizedBox(width: 6),
                    Text(priceOld,
                        style: const TextStyle(
                          color: AppColors.subtext,
                          decoration: TextDecoration.lineThrough,
                        )),
                  ],
                ),
                const SizedBox(height: 2),
                Text(items, style: const TextStyle(color: AppColors.subtext)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoBubble() => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: const Icon(Icons.store_rounded, color: AppColors.teal),
  );
}

// ----------------------------- TAB 2: LIVE BID -----------------------------
class _LiveBidTab extends StatelessWidget {
  const _LiveBidTab();

  @override
  Widget build(BuildContext context) {
    // same content layout, header text differs to match the “Live Bid Status” mock
    const list = <_SummaryStore>[
      _SummaryStore('Kroger', '14 Mar 2025  •  3:45pm', '\$210', '\$250', '11 items'),
      _SummaryStore('United Supermarkets', '7 Aug 2023 •  11:15am', '\$350', '\$345', '20 items'),
      _SummaryStore('Aldi', '7 Aug 2023 •  5:55pm', '\$320', '\$360', '15 items'),
      _SummaryStore('Walmart', '25 Dec 2024 •  6:30pm', '\$350', '\$380', '18 items'),
      _SummaryStore('Fred Myers', '7 Aug 2023 •  7:35am', '\$400', '\$420', '17 items'),
    ];

    return Column(
      children: [
        Container(
          color: AppColors.bg,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: const [
              Icon(Icons.schedule, color: AppColors.subtext, size: 16),
              SizedBox(width: 6),
              Text('1:25',
                  style:
                  TextStyle(color: AppColors.subtext, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
            itemBuilder: (_, i) {
              final s = list[i];
              return _StoreSummaryTile(
                name: s.name,
                when: s.when,
                priceNow: s.priceNow,
                priceOld: s.priceOld,
                items: s.items,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CompareStoreDetailScreen(
                      storeName: s.name,
                      items: _items,
                      totalNow: '\$400',
                      totalOld: '\$482',
                      showNAForSome: s.name == 'Kroger',
                    ),
                  ));
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: list.length,
          ),
        ),
      ],
    );
  }
}

// ----------------------------- STORE DETAIL (Walmart/Kroger) -----------------------------
class CompareStoreDetailScreen extends StatelessWidget {
  const CompareStoreDetailScreen({
    super.key,
    required this.storeName,
    required this.items,
    required this.totalNow,
    required this.totalOld,
    this.showNAForSome = false,
  });

  final String storeName;
  final List<_ItemRowData> items;
  final String totalNow;
  final String totalOld;
  final bool showNAForSome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.teal,
                elevation: 0,
                collapsedHeight: 72,
                titleSpacing: 0,
                title: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const BackButton(color: Colors.white),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 22),
                        const SizedBox(width: 8),
                        Text(storeName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            // TODO: open add item overlay
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add item',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
              ),

              // Header row: "Order" + count + total pill
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      const Text('Order',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text)),
                      const SizedBox(width: 8),
                      _badge('${items.length}'),
                      const Spacer(),
                      _totalPill(totalNow, totalOld),
                    ],
                  ),
                ),
              ),

              SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final it = items[i];
                  // mark a couple as N/A for the Kroger mock
                  final na = showNAForSome && (i == 1 || i == 2);
                  return _CompareItemRow(
                    data: it.copyWith(na: na),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // Checkout button
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.teal,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.12),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    // TODO: checkout for selected store
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  child: const Text('Checkout',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFF1F6C67).withOpacity(.12),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(text,
        style: const TextStyle(
            color: AppColors.teal, fontWeight: FontWeight.w700)),
  );

  Widget _totalPill(String now, String old) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6C67).withOpacity(.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Text(now,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.teal, fontSize: 16)),
          const SizedBox(width: 8),
          Text(old,
              style: const TextStyle(
                color: AppColors.teal,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2,
              )),
        ],
      ),
    );
  }
}

// ----------------------------- ITEM ROW -----------------------------
class _CompareItemRow extends StatelessWidget {
  const _CompareItemRow({required this.data});
  final _ItemRowData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _emoji(data.emoji),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
                  const SizedBox(height: 4),
                  Text(data.unit, style: const TextStyle(color: AppColors.subtext)),
                  const SizedBox(height: 2),
                  Text(data.price,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            data.na ? _naTag() : const _QtyPillSmall(),
          ],
        ),
      ),
    );
  }

  Widget _emoji(String e) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(12),
    ),
    alignment: Alignment.center,
    child: Text(e, style: const TextStyle(fontSize: 24)),
  );

  Widget _naTag() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF2E8E6),
      borderRadius: BorderRadius.circular(999),
    ),
    child: const Text('N/A',
        style: TextStyle(
          color: Color(0xFFB06054),
          fontWeight: FontWeight.w700,
        )),
  );
}

class _QtyPillSmall extends StatelessWidget {
  const _QtyPillSmall();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EFEF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _circle(Icons.remove),
          const SizedBox(width: 10),
          const Text('3',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(width: 10),
          _circle(Icons.add),
        ],
      ),
    );
  }

  Widget _circle(IconData icon) => Container(
    width: 32,
    height: 32,
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: Icon(icon, color: AppColors.text),
  );
}

// tiny helper to copy with NA flag
extension on _ItemRowData {
  _ItemRowData copyWith({bool? na}) =>
      _ItemRowData(emoji: emoji, name: name, unit: unit, price: price, na: na ?? this.na);
}
