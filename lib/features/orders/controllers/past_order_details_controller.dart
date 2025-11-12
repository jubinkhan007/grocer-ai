// lib/features/orders/controllers/past_order_details_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart';
import 'package:grocer_ai/features/orders/services/order_service.dart';

class PastOrderDetailsController extends GetxController {
  final OrderService _service;
  final int orderId;

  PastOrderDetailsController(this._service, {required this.orderId});

  final Rxn<Order> order = Rxn<Order>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      isLoading.value = true;
      order.value = await _service.fetchOrderDetails(orderId);
    } catch (e) {
      Get.snackbar('Error', 'Could not load order details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}