import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/views/past_order_details_screen.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';
import '../widgets/orders_widgets.dart';
import 'order_details_screen.dart';

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
  void _goToDetails() => Get.to(() => const OrderDetailsScreen());           // Current tab
  void _goToPastDetails() => Get.to(() => const PastOrderDetailsScreen());   // 👈 NEW for History tab
  @override
  Widget build(BuildContext context) {
    // Figma: Status bar ~48 + title block 69 => ~117
    const double headerHeight = 117;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6), // Figma bg
      body: CustomScrollView(
        slivers: [
          // status bar strip (dark like Figma)
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: const Color(0xFF002C2E),
            ),
          ),

// compact pinned header (64 px under the status bar)
          SliverPersistentHeader(
            pinned: true,
            delegate: _OrderHeader(
              height: 64,
              title: 'Order',
              showRange: _segIndex == 1,
              rangeText: _historyRange,
              onPickRange: (picked) {
                if (picked != null) {
                  setState(() => _historyRange = picked);
                  _loadHistory(picked);
                }
              },
            ),
          ),
          // Segmented control (top = 146 in figma; padding here yields same visual)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
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
                    onTap: () => _switchSeg(1),
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_segIndex == 0)
          // 👇 tap anywhere on the card list (Current) to open details
            SliverToBoxAdapter(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToDetails,
                child: CurrentList(),
              ),
            )
          else
            SliverList.list(children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPastDetails,        // 👈 History → PastOrderDetailsScreen
                child: const HistoryGroup(
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
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPastDetails,
                child: const HistoryGroup(
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
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPastDetails,
                child: const HistoryGroup(
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
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPastDetails,
                child: const HistoryGroup(
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
              ),
              const SizedBox(height: 24),

              // (If you keep these duplicates, make them tappable too)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPastDetails,
                child: HistoryGroup(
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
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPastDetails,
                child: HistoryGroup(
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
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goToPastDetails,
                child: HistoryGroup(
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
              ),
              const SizedBox(height: 24),
            ]),
        ],
      ),
      // bottomNavigationBar: FFBottomNav(currentIndex: _tab, onTap: _onNavTap),
    );
  }
}

class _OrderHeader extends SliverPersistentHeaderDelegate {
  _OrderHeader({
    required this.height,
    required this.title,
    required this.showRange,
    required this.rangeText,
    required this.onPickRange,
  });

  final double height;
  final String title;
  final bool showRange;
  final String rangeText;
  final ValueChanged<String?> onPickRange;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: const Color(0xFF33595B),
      child: Padding(
        // Figma: 24 horizontal, 12 vertical (visually gives ~64 height)
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(Size(20, 20)),
            ),
            const SizedBox(width: 8),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFEFEFE),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
            const Spacer(),
            if (showRange)
              _RangeDropdownButton(
                text: rangeText,
                onSelected: onPickRange,
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _OrderHeader old) =>
      old.height != height ||
          old.title != title ||
          old.showRange != showRange ||
          old.rangeText != rangeText;
}

class _RangeDropdownButton extends StatefulWidget {
  const _RangeDropdownButton({required this.text, required this.onSelected});
  final String text;
  final ValueChanged<String?> onSelected;

  @override
  State<_RangeDropdownButton> createState() => _RangeDropdownButtonState();
}

class _RangeDropdownButtonState extends State<_RangeDropdownButton> {
  final GlobalKey _btnKey = GlobalKey();

  Future<void> _openMenu() async {
    final box = _btnKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);

    final picked = await showMenu<String>(
      context: context,
      color: const Color(0xFF33595B), // dark teal panel
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      position: RelativeRect.fromLTRB(
        offset.dx + box.size.width - 8,               // right-align to button
        offset.dy + box.size.height + 6,              // small gap below
        overlay.size.width - offset.dx,
        0,
      ),
      items: const [
        PopupMenuItem<String>(
          value: 'Last month',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last month',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Last 2 months',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last 2 months',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Last 3 months',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last 3 months',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Last 6 months',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text('Last 6 months',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );

    widget.onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    // Trigger chip (rounded, darker than app bar, white text)
    return GestureDetector(
      key: _btnKey,
      onTap: _openMenu,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2D5153),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                color: Color(0xFFFEFEFE),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFEFEFE), size: 18),
          ],
        ),
      ),
    );
  }
}
