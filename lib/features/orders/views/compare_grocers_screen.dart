import 'package:flutter/material.dart';
import 'package:grocer_ai/features/orders/views/store_order_screen.dart';
import '../../../ui/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Palette taken from the Figma export
const _statusBar = Color(0xFF002C2E);
const _teal = Color(0xFF33595B);
const _cardBg = Color(0xFFFEFEFE);
const _tileIconBg = Color(0xFFF4F6F6);
const _textPrimary = Color(0xFF212121);
const _textSecondary = Color(0xFF4D4D4D);
const _muted = Color(0xFF6A6A6A);
const _dot = Color(0xFF8AA0A1);
const _divider = Color(0xFFDEE0E0);

class CompareGrocersScreen extends StatefulWidget {
  const CompareGrocersScreen({super.key});

  @override
  State<CompareGrocersScreen> createState() => _CompareGrocersScreenState();
}

class _CompareGrocersScreenState extends State<CompareGrocersScreen> {
  bool _live = false; // false = Comparison Summary, true = Live Bid Status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Column(
        children: [
          // Fake status bar color strip (matches Figma's very dark green)
          _TopHeader(
            live: _live,
            onTapAction: () => setState(() => _live = !_live),
          ),

          // CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 19, 24, 24),
              children: [
                if (!_live) ..._summaryTiles(context) else ..._liveTiles(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------- DATA (exact order/values from the Figma) ---------------------

  List<Widget> _summaryTiles(BuildContext context) =>
      [
        _BidTile(
          logo: Image.asset('assets/images/walmart.png'),
          name: 'Walmart',
          date: '25 Dec 2024',
          time: '6:30pm',
          now: '\$210',
          old: '\$250',
          items: '15 items',
          onTap: () => _openStore(context, 'Walmart'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/kroger.png'),
          name: 'Kroger',
          date: '14 Mar 2025',
          time: '3:45pm',
          now: '\$350',
          old: '\$345',
          items: '22 items',
          onTap: () => _openStore(context, 'Kroger'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/aldi.png'),
          name: 'Aldi',
          date: '7 Aug 2023',
          time: '11:15am',
          now: '\$320',
          old: '\$360',
          items: '19 items',
          onTap: () => _openStore(context, 'Aldi'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/fred_meyer.png'),
          name: 'Fred Myers',
          date: '7 Aug 2023',
          time: '9:45am',
          now: '\$350',
          old: '\$380',
          items: '14 items',
          onTap: () => _openStore(context, 'Fred Myers'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/united_supermarkets.png'),
          name: 'United Supermarkets',
          date: '7 Aug 2023',
          time: '2:30pm',
          now: '\$400',
          old: '\$420',
          items: '12 items',
          onTap: () => _openStore(context, 'United Supermarkets'),
        ),
      ];

  List<Widget> _liveTiles(BuildContext context) =>
      [
        _BidTile(
          logo: Image.asset('assets/images/kroger.png'),
          name: 'Kroger',
          date: '14 Mar 2025',
          time: '3:45pm',
          now: '\$210',
          old: '\$250',
          items: '11 items',
          onTap: () => _openStore(context, 'Kroger'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/united_supermarkets.png'),
          name: 'United Supermarkets',
          date: '7 Aug 2023',
          time: '11:15am',
          now: '\$350',
          old: '\$345',
          items: '20 items',
          onTap: () => _openStore(context, 'United Supermarkets'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/aldi.png'),
          name: 'Aldi',
          date: '7 Aug 2023',
          time: '5:55pm',
          now: '\$320',
          old: '\$360',
          items: '15 items',
          onTap: () => _openStore(context, 'Aldi'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/walmart.png'),
          name: 'Walmart',
          date: '25 Dec 2024',
          time: '6:30pm',
          now: '\$350',
          old: '\$380',
          items: '18 items',
          onTap: () => _openStore(context, 'Walmart'),
        ),
        const SizedBox(height: 12),
        _BidTile(
          logo: Image.asset('assets/images/fred_meyer.png'),
          name: 'Fred Myers',
          date: '7 Aug 2023',
          time: '7:35am',
          now: '\$400',
          old: '\$420',
          items: '17 items',
          onTap: () => _openStore(context, 'Fred Myers'),
        ),
      ];

  void _openStore(BuildContext context, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoreOrderScreen(
          storeName: name,
          fromCompare: true, // ⬅️ this makes the CTA read “Checkout”
        ),
      ),
    );
  }
}
/// A single white card from the mock with exact paddings, type, dividers, etc.
class _BidTile extends StatelessWidget {
  const _BidTile({
    required this.logo,
    required this.name,
    required this.date,
    required this.time,
    required this.now,
    required this.old,
    required this.items,
    required this.onTap,
  });

  final Widget logo;
  final String name, date, time, now, old, items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 48x48 logo box
            SizedBox(
              width: 48,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _tileIconBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(child: logo),
              ),
            ),
            const SizedBox(width: 16),

            // Make the middle area flexible so it can shrink if needed
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LEFT: name + date/time (flexible with ellipsis)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _teal,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const _Dot(),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                time,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _textSecondary,
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

                  // Divider with no reserved width; padding comes from SizedBox
                  const SizedBox(width: 12),
                  const SizedBox(
                    height: 39,
                    child: VerticalDivider(
                      color: _divider,
                      thickness: 1,
                      width: 1,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // RIGHT: prices + items
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              now,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              old,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Make the whole card tappable without changing its look
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

/// Tiny green dot between date and time (exact color/size from Figma)
class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(color: _dot, shape: BoxShape.circle),
    );
  }
}

/// Gray logo box with a placeholder image size matching Figma exports
class _LogoBox extends StatelessWidget {
  const _LogoBox._(this.w, this.h);
  final double w;
  final double h;

  static Widget mock({double width = 24, double height = 24}) =>
      _LogoBox._(width, height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}




class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.live, required this.onTapAction});
  final bool live;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    // match dark icons on dark strip
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusBar,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // status bar strip (48.14 in Figma; 48 is fine)
        const SizedBox(height: 48, width: double.infinity, child: ColoredBox(color: _statusBar)),
        // toolbar (68 = 116 - 48)
        Container(
          height: 68,
          width: double.infinity,
          color: _teal,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // back chevron (14x20-ish visual) without extra hitbox padding
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                splashRadius: 22,
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 0),
              // title (truncates to keep chip visible)
              Expanded(
                child: Text(
                  live ? 'Live Bid Status' : 'Comparison Summary',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // action chip: Rebid (with refresh icon) OR timer
              TextButton(
                onPressed: onTapAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: _teal, // same as bar (Figma)
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!live) ...[
                      const Icon(Icons.refresh, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      const Text('Rebid',
                          style: TextStyle(
                            color: Color(0xFFFEFEFE),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ] else ...[
                      const Text('1:25',
                          style: TextStyle(
                            color: Color(0xFFFEFEFE),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
