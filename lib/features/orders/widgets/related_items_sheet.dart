// lib/features/orders/widgets/related_items_sheet.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// ---- Figma palette (exact) ----
const _sheetBg = Color(0xFFF4F6F6);
const _textPrimary = Color(0xFF212121);
const _textSecondary = Color(0xFF4D4D4D);
const _muted = Color(0xFF6A6A6A);
const _teal = Color(0xFF33595B);
const _divider = Color(0xFFE0E0E0);
const _tileIconBg = Color(0xFFF4F6F6);
const _nearWhite = Color(0xFFFEFEFE);

class RelatedItem {
  final String title;
  final String unit;
  final String price;
  final Widget? emoji; // emoji or brand icon
  const RelatedItem(this.title, this.unit, this.price, {this.emoji});
}

/// PUBLIC: open the bottom sheet
Future<void> showRelatedItemsBottomSheet(
    BuildContext context, {
      required List<RelatedItem> items,
      VoidCallback? onSkip,
      ValueChanged<RelatedItem>? onTapItem,
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,            // <-- allow going right up to the top inset
    enableDrag: false,            // <-- prevent the modal's own drag from fighting ours
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final h = MediaQuery.of(ctx).size.height;
      final initial = (422 / h).clamp(0.25, 0.95);

      return DraggableScrollableSheet(
        initialChildSize: initial,
        minChildSize: 0.25,
        maxChildSize: 1.0,        // <-- allow full height
        expand: false,            // <-- important when used inside a modal
        snap: true,
        snapSizes: const [0.25, 0.55, 1.0],
        builder: (context, scrollController) {
          return _RelatedItemsSheet(
            items: items,
            onSkip: onSkip,
            onTapItem: onTapItem,
            scrollController: scrollController,
          );
        },
      );
    },
  );
}


class _RelatedItemsSheet extends StatelessWidget {
  const _RelatedItemsSheet({
    required this.items,
    this.onSkip,
    this.onTapItem,
    required this.scrollController,
  });

  final List<RelatedItem> items;
  final VoidCallback? onSkip;
  final ValueChanged<RelatedItem>? onTapItem;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: ColoredBox(
        color: _sheetBg,
        child: CustomScrollView(
          controller: scrollController,                     // <-- key
          physics: const ClampingScrollPhysics(),
          slivers: [
            // top padding + handle + header as slivers
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            const SliverToBoxAdapter(child: _Handle()),
            const SliverToBoxAdapter(child: _Header()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // the list
            SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => Center(
                child: SizedBox(
                  width: 382,
                  child: _RelatedTile(
                    data: items[i],
                    onTap: () => onTapItem?.call(items[i]),
                    tileColor: i.isOdd ? _nearWhite : Colors.white,
                  ),
                ),
              ),
            ),

            // bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}


class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row (382 wide = 430 - 24 - 24; centered)
        Center(
          child: SizedBox(
            width: 382,
            height: 48, // visual height of the top bar area in the comp
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: title + badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Related items',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // The count chip sits ~2px lower in Figma; nudge for baseline match
                    Transform.translate(
                      offset: const Offset(0, 2),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _teal,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Text(
                          '13', // you can also pass the dynamic count in if desired
                          style: TextStyle(
                            color: Color(0xFFFEFEFE),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Right: Skip
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: _teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: _divider, height: 1, thickness: 1),
      ],
    );
  }
}



class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: 88,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.58),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE3E3E3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _FrostedHandle extends StatelessWidget {
  const _FrostedHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      // no extra drop shadows — figma’s header has essentially none
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: 88,                  // figma pill width
            height: 24,                 // slimmer than before (was 28)
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.58), // subtle frosted look
              borderRadius: BorderRadius.circular(28),
            ),
            // the grabber
            child: Container(
              width: 36,                // figma-ish 36×4
              height: 4,                // thinner bar (was 6)
              decoration: BoxDecoration(
                color: const Color(0xFFE3E3E3), // slightly darker than before
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single related-item card (16x12 padding, r=8, 64 icon square)
class _RelatedTile extends StatelessWidget {
  const _RelatedTile({
    required this.data,
    required this.onTap,
    required this.tileColor,
  });

  final RelatedItem data;
  final VoidCallback onTap;
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tileColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 64 × 64 icon square (r=4)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _tileIconBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: data.emoji ?? const Text('🫙', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),

              // Text block (matches Figma type)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.unit,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.price,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
extension RelatedTileText on _RelatedTile {
  Widget build(BuildContext context) {
    return Material(
      color: tileColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _tileIconBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: data.emoji ?? const Text('🫙', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.unit,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.price,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
