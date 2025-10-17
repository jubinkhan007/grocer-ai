import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';
import '../widgets/orders_widgets.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // Set this to your bottom-nav index for "Order"
  int _tab = 2;

  int _segIndex = 0; // 0 = Current, 1 = History
  String _historyRange = 'Last 3 months';

  // 🔌 API hook – keep signatures and replace bodies later
  Future<void> _loadCurrent() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    // TODO: call service for current orders
  }

  Future<void> _loadHistory(String range) async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    // TODO: call service for history (range)
  }

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  void _switchSeg(int index) {
    if (_segIndex == index) return;
    setState(() => _segIndex = index);
    if (index == 0) {
      _loadCurrent();
    } else {
      _loadHistory(_historyRange);
    }
  }

  void _onNavTap(int i) {
    if (i == _tab) return;
    setState(() => _tab = i);
    // TODO: route switch for other tabs if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.teal,
            collapsedHeight: 72,
            expandedHeight: 92,
            titleSpacing: 0,
            title: TitleBar(
              showRange: _segIndex == 1,
              rangeText: _historyRange,
              onRangeTap: () async {
                // simple pop menu (static for now)
                final picked = await showMenu<String>(
                  context: context,
                  position: const RelativeRect.fromLTRB(200, 90, 16, 0),
                  items: const [
                    PopupMenuItem(value: 'Last 30 days', child: Text('Last 30 days')),
                    PopupMenuItem(value: 'Last 3 months', child: Text('Last 3 months')),
                    PopupMenuItem(value: 'Last 6 months', child: Text('Last 6 months')),
                  ],
                );
                if (picked != null) {
                  setState(() => _historyRange = picked);
                  _loadHistory(picked);
                }
              },
            ),
          ),

          // Segmented control
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  SegButton(
                    text: 'Current',
                    selected: _segIndex == 0,
                    onTap: () => _switchSeg(0),
                  ),
                  const SizedBox(width: 16),
                  SegButton(
                    text: 'History',
                    selected: _segIndex == 1,
                    filled: true,
                    onTap: () => _switchSeg(1),
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_segIndex == 0)
            SliverToBoxAdapter(child: CurrentList())
          else
            SliverList.list(children: const [
              HistoryGroup(
                dateLabel: '22 Sep 2024',
                tiles: [
                  OrderTileData(
                    logo: 'assets/images/walmart.png',
                    brand: 'Walmart',
                    status: OrderStatus.completed,
                    priceNow: '\$400',
                    priceOld: '\$482',
                    itemsText: '12 items',
                  ),
                ],
              ),
              HistoryGroup(
                dateLabel: '16 Sep 2024',
                tiles: [
                  OrderTileData(
                    logo: 'assets/images/kroger.png',
                    brand: 'Kroger',
                    status: OrderStatus.completed,
                    priceNow: '\$700',
                    priceOld: '\$759',
                    itemsText: '15 items',
                  ),
                  OrderTileData(
                    logo: 'assets/images/aldi.png',
                    brand: 'Aldi',
                    status: OrderStatus.cancelled,
                    priceNow: '\$300',
                    priceOld: '\$316',
                    itemsText: '9 items',
                  ),
                ],
              ),
              HistoryGroup(
                dateLabel: '06 Sep 2024',
                tiles: [
                  OrderTileData(
                    logo: 'assets/images/aldi.png',
                    brand: 'Aldi',
                    status: OrderStatus.completed,
                    priceNow: '\$300',
                    priceOld: '\$316',
                    itemsText: '9 items',
                  ),
                ],
              ),
              HistoryGroup(
                dateLabel: '27 Aug 2024',
                tiles: [
                  OrderTileData(
                    logo: 'assets/images/walmart.png',
                    brand: 'Walmart',
                    status: OrderStatus.completed,
                    priceNow: '\$400',
                    priceOld: '\$482',
                    itemsText: '12 items',
                  ),
                ],
              ),
              SizedBox(height: 24),
            ]),
        ],
      ),
      bottomNavigationBar: FFBottomNav(currentIndex: _tab, onTap: _onNavTap),
    );
  }
}
