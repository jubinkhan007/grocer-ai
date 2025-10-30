import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/controllers/compare_grocers_controller.dart';
import 'package:grocer_ai/features/orders/models/compare_bid_model.dart';
// Note: store_order_screen.dart is imported by the controller

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

// --- MODIFIED: Converted to GetView ---
class CompareGrocersScreen extends GetView<CompareGrocersController> {
  const CompareGrocersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Column(
        children: [
          // --- MODIFIED: Header now observes controller state ---
          Obx(() => _TopHeader(
            live: controller.isLive.value,
            isRebidding: controller.isRebidding.value,
            timeText: controller.formattedTime,
            onTapAction: () {
              if (controller.isLive.value) {
                controller.toggleLiveView(); // Switch back to summary
              } else {
                controller.handleRebid(); // Perform rebid
              }
            },
          )),

          // CONTENT
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.bids.isEmpty) {
                return const Center(child: Text('No bids found.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 19, 24, 120),
                itemCount: controller.bids.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final bid = controller.bids[index];
                  // --- MODIFIED: Build tiles dynamically ---
                  return _BidTile(
                    logo: Image.asset(
                      bid.provider.localLogoAsset, // Use local asset helper
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.store, color: _teal),
                    ),
                    name: bid.provider.name,
                    date: '2025-10-30', // Mock data, API doesn't provide this
                    time: '6:30pm', // Mock data, API doesn't provide this
                    now: '\$${bid.discountedPrice}',
                    old: '\$${bid.totalPrice}',
                    items: '${bid.totalItems} items',
                    onTap: () => controller.selectStore(bid),
                  );
                },
              );
            }),
          ),
        ],
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

// --- MODIFIED: Header now shows loading state ---
class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.live,
    required this.onTapAction,
    required this.isRebidding,
    required this.timeText,
  });
  final bool live;
  final bool isRebidding;
  final VoidCallback onTapAction;
  final String timeText;

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
        SizedBox(
            height: MediaQuery.of(context).padding.top,
            width: double.infinity,
            child: const ColoredBox(color: _statusBar)),
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
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                splashRadius: 22,
                icon: const Icon(Icons.chevron_left,
                    color: Colors.white, size: 28),
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
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextButton(
                  onPressed: isRebidding ? null : onTapAction,
                  style: TextButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: _teal, // same as bar (Figma)
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: isRebidding
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child:
                    CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!live) ...[
                        const Icon(Icons.refresh,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        const Text('Rebid',
                            style: TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                      ] else ...[
                        // TODO: Implement live timer
                        Text(timeText,
                            style: const TextStyle(
                              color: Color(0xFFFEFEFE),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
