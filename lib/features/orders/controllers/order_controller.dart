// lib/features/orders/controllers/order_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/orders/models/order_list_model.dart';
import 'package:grocer_ai/features/orders/models/order_models.dart';
import 'package:grocer_ai/features/orders/services/order_service.dart';

class OrderController extends GetxController {
  final OrderService _service;
  OrderController(this._service);

  final segIndex = 0.obs;
  final isLoadingCurrent = true.obs;
  final isLoadingHistory = true.obs;

  final Rxn<Order> currentOrder = Rxn<Order>();
  final RxList<OrderList> orderHistory = <OrderList>[].obs;

  final RxMap<String, List<OrderList>> groupedHistory =
      <String, List<OrderList>>{}.obs;

  // TODO: Implement range filter logic
  final historyRange = 'Last 3 months'.obs;

  @override
  void onInit() {
    super.onInit();
    // Load both, but user only sees one at a time
    _loadCurrent();
    _loadHistory();
  }

  Future<void> _loadCurrent() async {
    try {
      isLoadingCurrent.value = true;
      currentOrder.value = await _service.fetchCurrentOrder();
    } catch (e) {
      Get.snackbar('Error loading current order', e.toString());
    } finally {
      isLoadingCurrent.value = false;
    }
  }

  Future<void> _loadHistory() async {
    try {
      isLoadingHistory.value = true;
      final list = await _service.fetchOrderHistory();
      // Sort by date descending before grouping
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      orderHistory.assignAll(list);
      _groupHistory();
    } catch (e) {
      Get.snackbar('Error loading order history', e.toString());
    } finally {
      isLoadingHistory.value = false;
    }
  }

  void _groupHistory() {
    final groups = <String, List<OrderList>>{};
    for (final order in orderHistory) {
      final dateString = order.formattedDate; // Use helper from model
      if (groups.containsKey(dateString)) {
        groups[dateString]!.add(order);
      } else {
        groups[dateString] = [order];
      }
    }
    groupedHistory.value = groups;
  }

  void switchSeg(int index) {
    if (segIndex.value == index) return;
    segIndex.value = index;
    if (index == 0) {
      _loadCurrent(); // Re-fetch on switch
    } else {
      _loadHistory(); // Re-fetch on switch
    }
  }

  void setHistoryRange(String range) {
    historyRange.value = range;
    _loadHistory(); // Re-fetch with new range
  }
}