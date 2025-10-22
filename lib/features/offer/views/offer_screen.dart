import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shell/main_shell_controller.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  // set this to the index that represents "Offer" in your nav
  // (change to whatever your FFBottomNav index is for Offer)
  int _tab = 1;

  // 🔌 API hook – keep this signature; wire service later
  Future<void> _loadOffers() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    // TODO: call OfferService.fetch() and setState with results
  }

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  void _onNavTap(int i) {
    // ask the shell to switch tab
    Get.find<MainShellController>().goTo(i);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
        SliverAppBar(
        backgroundColor: AppColors.teal,
        pinned: true,
        expandedHeight: 122,
        collapsedHeight: 88,
        centerTitle: false,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          // bottom padding for the collapsed title
          titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          // ONE title that morphs between expanded/compact
          title: const _CollapsingHeaderTitle(),
          // no text here, only color (or image) so we don't double-draw
          background: const ColoredBox(color: AppColors.teal),
        ),
      ),


      // Walmart
          SliverToBoxAdapter(
            child: _StoreSection(
              logo: 'assets/images/walmart.png', // optional asset
              title: 'Walmart',
              products: const [
                _P(title: 'Bell Pepper Red', priceNow: '\$11', priceOld: '\$14', save: 'Save 20%', image: 'assets/products/red_pepper.png'),
                _P(title: 'Arabic Ginger', priceNow: '\$19', priceOld: '\$21', save: 'Save 19%', image: 'assets/products/ginger.png'),
                _P(title: 'Fresh Lettuce', priceNow: '\$14', priceOld: '\$20', save: 'Save 18%', image: 'assets/products/lettuce.png'),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: _DividerGutter()),

          // Kroger
          SliverToBoxAdapter(
            child: _StoreSection(
              logo: 'assets/images/kroger.png',
              title: 'Kroger',
              products: const [
                _P(title: 'Butternut Squash', priceNow: '\$17', priceOld: '\$24', save: 'Save 20%', image: 'assets/products/squash.png'),
                _P(title: 'Organic Carrots', priceNow: '\$16', priceOld: '\$23', save: 'Save 10%', image: 'assets/products/carrots.png'),
                _P(title: 'Broccoli', priceNow: '\$18', priceOld: '\$19', save: 'Save 12%', image: 'assets/products/broccoli.png'),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: _DividerGutter()),

          // Aldi
          SliverToBoxAdapter(
            child: _StoreSection(
              logo: 'assets/images/aldi.png',
              title: 'Aldi',
              products: const [
                _P(title: 'Fresh Beef', priceNow: '\$22', priceOld: '\$28', save: 'Save 22%', image: 'assets/products/beef.png'),
                _P(title: 'Tomatoes', priceNow: '\$12', priceOld: '\$16', save: 'Save 25%', image: 'assets/products/tomatoes.png'),
                _P(title: 'Spinach', priceNow: '\$9', priceOld: '\$11', save: 'Save 15%', image: 'assets/products/spinach.png'),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      // bottomNavigationBar: FFBottomNav(currentIndex: _tab, onTap: _onNavTap),
    );
  }
}

/// Header: teal, “Hi, Joshep” + location + bell
class _OfferHeader extends StatelessWidget {
  const _OfferHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.teal,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Hi, Joshep',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              color: Colors.white70, size: 18),
                          SizedBox(width: 6),
                          Text('Savar, Dhaka',
                              style:
                              TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {}, // TODO: open notifications
                      icon: const Icon(Icons.notifications_none_rounded,
                          color: Colors.white, size: 26),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A store section with logo + title + horizontal product list
class _StoreSection extends StatelessWidget {
  const _StoreSection({
    required this.logo,
    required this.title,
    required this.products,
  });

  final String logo;
  final String title;
  final List<_P> products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            // logo (optional asset)
            Image.asset(
              logo,
              width: 26,
              height: 26,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.storefront, color: AppColors.teal, size: 22),
            ),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text)),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ListView.separated(
              padding: const EdgeInsets.only(right: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) => _ProductCard(p: products[i]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Product data (static for now, API later)
class _P {
  final String title;
  final String priceNow;
  final String priceOld;
  final String save;
  final String image;
  const _P({
    required this.title,
    required this.priceNow,
    required this.priceOld,
    required this.save,
    required this.image,
  });
}

/// Product card with “Save %” ribbon
class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.p});
  final _P p;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product image
                Expanded(
                  child: Center(
                    child: Image.asset(
                      p.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: AppColors.subtext,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(p.priceNow,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text)),
                    const SizedBox(width: 10),
                    Text(
                      p.priceOld,
                      style: const TextStyle(
                        color: AppColors.subtext,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // “Save 20%” ribbon
        Positioned(
          left: 12,
          top: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2C6C66), // deep teal like mock
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              p.save,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _DividerGutter extends StatelessWidget {
  const _DividerGutter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Divider(color: AppColors.divider.withOpacity(.7), height: 1),
    );
  }
}
class _CollapsingHeaderTitle extends StatelessWidget {
  const _CollapsingHeaderTitle();

  @override
  Widget build(BuildContext context) {
    final settings =
    context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

    // Fallback if not inside a FlexibleSpaceBar
    double t = 0.0;
    if (settings != null && settings.maxExtent > settings.minExtent) {
      t = ((settings.currentExtent - settings.minExtent) /
          (settings.maxExtent - settings.minExtent))
          .clamp(0.0, 1.0);
    }

    final bool expanded = t > 0.6; // threshold where we switch layouts
    return _HeaderRow(compact: !expanded);
  }
}


class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Joshep',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 20 : 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Colors.white70, size: 18),
                  SizedBox(width: 6),
                  Text('Savar, Dhaka',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded,
                  color: Colors.white, size: 26),
            ),
            const Positioned(
              right: 10, top: 10,
              child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
