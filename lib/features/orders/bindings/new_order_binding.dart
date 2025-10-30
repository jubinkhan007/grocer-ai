// lib/features/orders/bindings/new_order_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/orders/controllers/new_order_controller.dart';
import 'package:grocer_ai/features/orders/services/order_preference_service.dart';

class NewOrderBinding extends Bindings {
  @override
  void dependencies() {
    final client = Get.find<DioClient>();
    Get.lazyPut<NewOrderController>(() => NewOrderController(client));
  }
}