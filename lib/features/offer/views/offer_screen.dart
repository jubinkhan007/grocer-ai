// lib/features/offer/views/offer_screen.dart

import 'package:dio/dio.dart'; // Import dio
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../shell/main_shell_controller.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';

// Import new models and service
import '../data/product_model.dart';
import '../data/provider_model.dart';
import '../services/offer_service.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

const kTeal = Color(0xFF33595B);
const kAppBarH = 92.0;
class _OfferScreenState extends State<OfferScreen> {
  int _tab = 1; // (change to whatever your FFBottomNav index is for Offer)

  // 🔌 Service and state variables
  late final OfferService _offerService;
  bool _isLoading = true;
  List<ProviderWithProducts> _offerData = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initialize the service with a Dio instance
    _offerService = OfferService(Dio());
    _loadOffers();
  }

  // 🔌 API hook
  Future<void> _loadOffers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _offerService.getOffers();
      setState(() {
        _offerData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load offers. Please try again.";
        _isLoading = false;
        print(e); // For debugging
      });
    }
  }

  void _onNavTap(int i) {
    // ask the shell to switch tab
    Get.find<MainShellController>().goTo(i);
  }

  // Helper to map API Product to UI _P model
  _P _mapProductToP(Product product) {
    final priceOldNum = double.tryParse(product.price) ?? 0.0;
    final discount = product.discount;
    final priceNowNum = priceOldNum - (priceOldNum * discount / 100);

    return _P(
      title: product.name,
      // Format prices to match your original UI
      priceNow: '\$${priceNowNum.toStringAsFixed(priceNowNum.truncateToDouble() == priceNowNum ? 0 : 2)}',
      priceOld: '\$${priceOldNum.toStringAsFixed(priceOldNum.truncateToDouble() == priceOldNum ? 0 : 2)}',
      save: 'Save $discount%',
      image: product.image, // This is now a URL
    );
  }

  // Helper to dynamically build the store sections
  List<Widget> _buildStoreSections() {
    final List<Widget> sections = [];

    if (_offerData.isEmpty && !_isLoading) {
      sections.add(const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: Center(child: Text("No offers available right now.")),
        ),
      ));
      return sections;
    }

    for (int i = 0; i < _offerData.length; i++) {
      final item = _offerData[i];
      final productsAsP = item.products.map((p) => _mapProductToP(p)).toList();

      sections.add(SliverToBoxAdapter(
        child: _StoreSection(
          logo: item.provider.logo, // This is now a URL
          title: item.provider.name,
          products: productsAsP,
        ),
      ));

      // Add divider if not the last item
      if (i < _offerData.length - 1) {
        sections.add(const SliverToBoxAdapter(child: _DividerGutter()));
      }
    }

    // Add final padding
    sections.add(const SliverToBoxAdapter(child: SizedBox(height: 24)));
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ColoredBox(
          color: const Color(0xFFF4F6F6),
          child: SafeArea(
              top: false,
              bottom: false,
              child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          backgroundColor: kTeal,
                          surfaceTintColor: Colors.transparent,
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          shadowColor: Colors.transparent,
                          pinned: true,

                          // 👇 Compact heights
                          toolbarHeight: kAppBarH,
                          expandedHeight: kAppBarH,
                          collapsedHeight: kAppBarH,

                          titleSpacing: 0,
                          systemOverlayStyle: const SystemUiOverlayStyle(
                            statusBarColor: kTeal,
                            statusBarIconBrightness: Brightness.light,
                            statusBarBrightness: Brightness.dark, // iOS
                          ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), // was 16
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center, // keep text vertically centered
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text.rich(TextSpan(children: [
                                        TextSpan(text: 'Hi,', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFFFEFEFE))),
                                        TextSpan(text: ' '),
                                        TextSpan(text: 'Joshep', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFFEFEFE))),
                                      ])),
                                      SizedBox(height: 4), // tighter
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined, size: 18, color: Color(0xFFE9E9E9)),
                                          SizedBox(width: 6),
                                          Text('Savar, Dhaka', style: TextStyle(fontSize: 13, color: Color(0xFFE9E9E9))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    icon: Icon(Icons.notifications_none_rounded, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Handle Loading and Error states
                        if (_isLoading)
                          const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_error != null)
                          SliverFillRemaining(
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(_error!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red)),
                                )),
                          )
                        else
                        // Dynamically build store sections
                          ..._buildStoreSections(),
                      ],
                    ),
                  )))),
      // bottomNavigationBar: FFBottomNav(currentIndex: _tab, onTap: _onNavTap),
    );
  }
}

/// Header: teal, “Hi, Joshep” + location + bell
/// This widget is no longer used by SliverAppBar, but kept for reference
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

  final String logo; // This is now a URL
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
              // *** MODIFIED HERE: Use Image.network for the logo ***
              SizedBox(
                width: 20,
                height: 20,
                child: Image.network(
                  logo,
                  fit: BoxFit.contain,
                  // Add error/loading builders for robustness
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.store, size: 20, color: Colors.grey);
                  },
                ),
              ),
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
  final String image; // This is now a URL
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
        color: const Color(0xFFE9E9E9), // light gray like mock
        borderRadius: BorderRadius.circular(8), // 8px radius
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
                color: Color(0xFF33595B), // deep teal (matches screenshot)
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
                // *** MODIFIED HERE: Use Image.network for the product image ***
                child: Image.network(
                  p.image,
                  fit: BoxFit.contain,
                  // Add error/loading builders for robustness
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported,
                        color: Colors.grey);
                  },
                ),
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

// ... (Rest of your helper widgets _CollapsingHeaderTitle and _HeaderRow remain unchanged) ...

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
                  fontSize: compact ? 20 : 24, // +2 when expanded
                  fontWeight: FontWeight.w700,
                  height: compact ? 1.15 : 1.20,
                ),
              ),
              const SizedBox(height: 8), // +2 for breathing room
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  Text('Savar, Dhaka',
                      style: TextStyle(color: Colors.white70, fontSize: 16)), // +2
                ],
              ),
            ],
          ),
        ),
        Padding(
          // align bell a bit lower
          padding: const EdgeInsets.only(top: 4),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white, size: 26),
              ),
              const Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(radius: 4, backgroundColor: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}