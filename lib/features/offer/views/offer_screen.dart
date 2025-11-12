// lib/features/offer/views/offer_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import '../../../shell/main_shell_controller.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';

// Import new models and service
import '../../shared/teal_app_bar.dart';
import '../controllers/offer_controller.dart';
import '../data/product_model.dart';
import '../data/provider_model.dart';
import '../services/offer_service.dart';

class OfferScreen extends GetView<OfferController> {
  const OfferScreen({super.key});

  // Helper to map API Product to UI _P model
  _P _mapProductToP(Product product) {
    final priceOldNum = double.tryParse(product.price) ?? 0.0;
    final discount = product.discount;
    final priceNowNum = priceOldNum - (priceOldNum * discount / 100);

    return _P(
      title: product.name,
      priceNow: '\$${priceNowNum.toStringAsFixed(priceNowNum.truncateToDouble() == priceNowNum ? 0 : 2)}',
      priceOld: '\$${priceOldNum.toStringAsFixed(priceOldNum.truncateToDouble() == priceNowNum ? 0 : 2)}',
      save: 'Save $discount%',
      image: product.image, // This is now a URL
    );
  }

  // --- 1. THIS IS THE FIX ---
  // Helper to dynamically build the store sections
  // This now returns a list of RenderBox widgets, NOT Slivers.
  List<Widget> _buildStoreSections() {
    final List<Widget> sections = [];

    if (controller.offerData.isEmpty && !controller.isLoading.value) {
      // --- MODIFIED: Removed SliverToBoxAdapter ---
      sections.add(const Padding(
        padding: EdgeInsets.all(48.0),
        child: Center(child: Text("No offers available right now.")),
      ));
      return sections;
    }

    for (int i = 0; i < controller.offerData.length; i++) {
      final item = controller.offerData[i];
      final productsAsP = item.products.map((p) => _mapProductToP(p)).toList();

      // --- MODIFIED: Removed SliverToBoxAdapter ---
      sections.add(_StoreSection(
        logo: item.provider.logo,
        title: item.provider.name,
        products: productsAsP,
      ));

      if (i < controller.offerData.length - 1) {
        // --- MODIFIED: Removed SliverToBoxAdapter ---
        sections.add(const _DividerGutter());
      }
    }

    // --- MODIFIED: Removed SliverToBoxAdapter ---
    sections.add(const SizedBox(height: 120)); // Padding for nav bar
    return sections;
  }
  // --- END FIX ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20 + 72),
        child: Obx(() => TealHomeAppBar(
          name: controller.userName.value,
          location: controller.location.value,
          showDot: controller.hasUnreadNotifications.value,
          onBellTap: () {
            Get.toNamed(Routes.notifications);
          },
        )),
      ),
      body: ColoredBox(
        color: const Color(0xFFF4F6F6),
        child: SafeArea(
          top: false,  // app bar already handles status bar
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: CustomScrollView( // <-- This is line 94
                slivers: [
                  // gap between teal header and content (matches home/dashboard)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),

                  // --- 2. THIS IS THE FIX ---
                  Obx(() {
                    if (controller.isLoading.value) {
                      // --- MODIFIED: Use SliverToBoxAdapter ---
                      return const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 300, // Give it some height
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    }

                    if (controller.error.value != null) {
                      // --- MODIFIED: Use SliverToBoxAdapter ---
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 300,
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(controller.error.value!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red)),
                              )),
                        ),
                      );
                    }

                    // This is now correct, as _buildStoreSections()
                    // returns a List<Widget> of RenderBoxes.
                    return SliverList( // <-- This is line 176
                      delegate: SliverChildListDelegate(
                        _buildStoreSections(),
                      ),
                    );
                  }),
                  // --- END FIX ---
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ... (Rest of the file: _StoreSection, _P, _ProductCard, _DividerGutter, etc. are all unchanged) ...

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
              SizedBox(
                width: 20,
                height: 20,
                child: Image.network(
                  logo,
                  fit: BoxFit.contain,
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
                child: Image.network(
                  p.image,
                  fit: BoxFit.contain,
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