// lib/features/orders/bindings/order_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/orders/controllers/order_controller.dart';
import 'package:grocer_ai/features/orders/services/order_service.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderService(Get.find<DioClient>()));
    Get.lazyPut(() => OrderController(Get.find<OrderService>()));
  }
}