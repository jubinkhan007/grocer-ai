// lib/features/orders/controllers/store_order_controller.dart
// NEW FILE
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ai/features/checkout/views/checkout_screen.dart';
import 'package:grocer_ai/features/orders/models/generated_order_model.dart';
import 'package:grocer_ai/features/orders/views/compare_grocers_screen.dart';
import 'package:grocer_ai/features/orders/views/store_add_item_screen.dart';
import 'package:grocer_ai/features/orders/widgets/related_items_sheet.dart';
import '../../../ui/theme/app_theme.dart';
import '../bindings/compare_grocer_binding.dart';

class StoreOrderController extends GetxController {
  // --- STATE ---
  final provider = Rxn<ProviderData>();
  final products = <ProductData>[].obs;
  final fromCompare = false.obs;

  @override
  void onInit() {
    super.onInit();
    _ingestArgs();

    final args = Get.arguments;

    // 1) Direct: arguments is the GeneratedOrderResponse itself
    if (args is GeneratedOrderResponse) {
      provider.value = args.provider;
      products.assignAll(args.products);
      // fromCompare stays false (normal flow)
      return;
    }

    // 2) Map: arguments contains orderData + fromCompare (compare flow)
    if (args is Map) {
      final od = args['orderData'];
      final fc = args['fromCompare'];

      if (od is GeneratedOrderResponse) {
        provider.value = od.provider;
        products.assignAll(od.products);
      }

      if (fc == true) {
        fromCompare.value = true; // <-- this makes the button read "Checkout"
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    // If re-used instance or args arrived later, ensure state is correct
    if (provider.value == null) {
      _ingestArgs();
    }
  }

  // --- UI ACTIONS ---

  void onAddItem() {
    Get.to(() => const StoreAddItemScreen());
  }

  void onCompareOrCheckout() {
    if (fromCompare.value) {
      Get.to(() => const CheckoutScreen());
    } else {
      // --- MODIFIED: Use Get.to() with binding ---
      Get.to(() => const CompareGrocersScreen(),
          binding: CompareGrocersBinding());
    }
  }

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

  void onItemTap(ProductData product) {
    // This sheet uses a different model, so we'll stub it
    // In a real app, you'd fetch related items for product.id
    showRelatedItemsBottomSheet(
      Get.context!,
      items: const [
        RelatedItem('Mediterranean Breeze Olive Oil', '\$75.30/litter', '\$23.8'),
        RelatedItem('Verdant Valley Olive Oil', '\$75.30/litter', '\$23.8'),
      ],
    );
  }

  Future<bool> onDismissConfirm(DismissDirection dir) async {
    return await _showDeleteDialog(Get.context!) ?? false;
  }

  void _ingestArgs() {
    final args = Get.arguments;
    // case 1: passed the whole GeneratedOrderResponse directly
    if (args is GeneratedOrderResponse) {
      provider.value = args.provider;
      products.assignAll(args.products);
      // fromCompare remains false
      return;
    }

    // case 2: passed as a Map { orderData, fromCompare }
    if (args is Map) {
      final od = args['orderData'];
      final fc = args['fromCompare'];

      if (od is GeneratedOrderResponse) {
        provider.value = od.provider;
        products.assignAll(od.products);
      }
      if (fc == true) {
        fromCompare.value = true;  // <-- switches CTA to "Checkout"
      }
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
                child: Image.asset('assets/icons/delete.png', height: 50, width: 50,),
              ),
              const SizedBox(height: 16),
              const Text('Delete item',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text)),
              const SizedBox(height: 8),
              const Text('Are you sure you want to delete this item?',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.subtext)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: teal, width: 2),
                        foregroundColor: teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Delete',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
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