// lib/features/orders/bindings/store_order_binding.dart
// NEW FILE
import 'package:get/get.dart';

import '../controllers/store_order_controller.dart';
class StoreOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<StoreOrderController>(() => StoreOrderController());
  }
}