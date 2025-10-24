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
        body: ColoredBox(
            color: const Color(0xFFF4F6F6),
            child: SafeArea(
                bottom: false,
                child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF33595B),
            pinned: true,
            expandedHeight: 92,       // header block height
            collapsedHeight: 92,
            titleSpacing: 0,          // so 24 actually is 24
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        // "Hi, Joshep" (from plugin: 18 regular + 18 bold)
                        Text.rich(TextSpan(children: [
                          TextSpan(text: 'Hi,',  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFFFEFEFE))),
                          TextSpan(text: ' '),
                          TextSpan(text: 'Joshep', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFFEFEFE))),
                        ])),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 20, color: Color(0xFFE9E9E9)),
                            SizedBox(width: 8),
                            Text('Savar, Dhaka', style: TextStyle(fontSize: 14, color: Color(0xFFE9E9E9))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 32, height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
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
                    ),
      // bottomNavigationBar: FFBottomNav(currentIndex: _tab, onTap: _onNavTap),
    )
            )
        )
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(logo, width: 20, height: 20, fit: BoxFit.contain),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF003032),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 221,
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
    return Container(
      width: 140,
      height: 221,
      // smaller card
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),           // light gray like mock
        borderRadius: BorderRadius.circular(8),   // 8px radius
      ),
      child: Stack(
        children: [
          // SAVE % ribbon in the top-left corner
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 64,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: const ShapeDecoration(
                color: Color(0xFF33595B),         // deep teal (matches screenshot)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
              child: Text(
                p.save,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // Card content
          Column(
            children: [
              const SizedBox(height: 50),
              SizedBox(
                width: 100,
                height: 76,
                child: Image.asset(p.image, fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          p.priceNow,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          p.priceOld,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6A6A6A),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DividerGutter extends StatelessWidget {
  const _DividerGutter();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFE6EAEB)),
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
                  fontSize: compact ? 20 : 24,     // +2 when expanded
                  fontWeight: FontWeight.w700,
                  height: compact ? 1.15 : 1.20,
                ),
              ),
              const SizedBox(height: 8),           // +2 for breathing room
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  Text('Savar, Dhaka', style: TextStyle(color: Colors.white70, fontSize: 16)), // +2
                ],
              ),
            ],
          ),
        ),
        Padding(                               // align bell a bit lower
          padding: const EdgeInsets.only(top: 4),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
              ),
              const Positioned(right: 10, top: 10, child: CircleAvatar(radius: 4, backgroundColor: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
