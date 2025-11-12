// lib/features/orders/bindings/past_order_details_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/controllers/past_order_details_controller.dart';
import 'package:grocer_ai/features/orders/services/order_service.dart';

class PastOrderDetailsBinding extends Bindings {
  final int orderId;
  PastOrderDetailsBinding({required this.orderId});

  @override
  void dependencies() {
    // Service is already registered in AppBindings, so we find it
    Get.lazyPut(() => PastOrderDetailsController(
      Get.find<OrderService>(),
      orderId: orderId,
    ));
  }
}