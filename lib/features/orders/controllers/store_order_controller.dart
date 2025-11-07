// lib/features/orders/controllers/store_order_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ai/app/app_routes.dart'; // <-- IMPORT app_routes.dart
import 'package:grocer_ai/features/orders/models/generated_order_model.dart';
import 'package:grocer_ai/features/orders/views/compare_grocers_screen.dart';
import 'package:grocer_ai/features/orders/views/store_add_item_screen.dart';
import 'package:grocer_ai/features/orders/widgets/related_items_sheet.dart';
import '../../../core/theme/network/dio_client.dart';
import '../../../ui/theme/app_theme.dart';
import '../bindings/compare_grocer_binding.dart';
import '../services/related_items_service.dart';

class StoreOrderController extends GetxController {
  // --- STATE ---
  final provider = Rxn<ProviderData>();
  final products = <ProductData>[].obs;
  final fromCompare = false.obs;

  late final RelatedItemsService _relatedSvc;
  final isLoadingRelated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _relatedSvc = RelatedItemsService(Get.find<DioClient>());
    _ingestArgs();
  }

  @override
  void onReady() {
    super.onReady();
    if (provider.value == null) {
      _ingestArgs();
    }
  }

  // --- UI ACTIONS ---

  void onAddItem() {
    Get.to(() => const StoreAddItemScreen());
  }

  // --- MODIFIED: THIS IS THE FIX ---
  void onCompareOrCheckout() {
    // Re-bundle the order data to pass to the next screen
    final currentOrderData = GeneratedOrderResponse(
      provider: provider.value!,
      products: products,
    );

    if (fromCompare.value) {
      // --- FIX: Was Get.to(), now Get.toNamed() ---
      Get.toNamed(
        Routes.checkout,
        arguments: {
          'orderData': currentOrderData,
          'fromCompare': true,
        },
      );
    } else {
      Get.to(() => const CompareGrocersScreen(),
          binding: CompareGrocersBinding());
    }
  }
  // --- END MODIFIED ---

  void onQtyMinus(ProductData product) {
    if (product.uiQuantity.value > 0) {
      product.uiQuantity.value--;
      // TODO: Add API call to update quantity
    }
  }

  void onQtyPlus(ProductData product) {
    product.uiQuantity.value++;
    // TODO: Add API call to update quantity
  }

  void onItemTap(ProductData product) async {
    try {
      isLoadingRelated.value = true;
      final results = await _relatedSvc.fetch(productId: product.id);
      final tiles = results.map((p) {
        final thumb = ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            p.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
            const Text('🫙', style: TextStyle(fontSize: 28)),
          ),
        );
        return RelatedItem(
          p.name,
          p.unitPrice,
          '\$${p.price}',
          emoji: thumb,
        );
      }).toList();

      await showRelatedItemsBottomSheet(
        Get.context!,
        items: tiles,
        onTapItem: (sel) {},
      );
    } catch (e) {
      Get.snackbar('Related items', 'Failed to load related products.');
    } finally {
      isLoadingRelated.value = false;
    }
  }

  Future<bool> onDismissConfirm(DismissDirection dir) async {
    return await _showDeleteDialog(Get.context!) ?? false;
  }

  void _ingestArgs() {
    final args = Get.arguments;
    if (args is GeneratedOrderResponse) {
      provider.value = args.provider;
      products.assignAll(args.products);
      return;
    }
    if (args is Map) {
      final od = args['orderData'];
      final fc = args['fromCompare'];
      if (od is GeneratedOrderResponse) {
        provider.value = od.provider;
        products.assignAll(od.products);
      }
      if (fc == true) fromCompare.value = true;
    }
  }

  void onItemDismissed(ProductData product) {
    products.remove(product);
    // TODO: Add API call to delete item
  }

  // --- PRIVATE HELPERS ---
  Future<bool?> _showDeleteDialog(BuildContext context) {
    const teal = Color(0xFF33595B);
    return showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/icons/delete.png',
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Delete item',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text)),
              const SizedBox(height: 8),
              const Text('Are you sure you want to delete this item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.subtext)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: teal, width: 2),
                        foregroundColor: teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Delete',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}