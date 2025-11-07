// lib/features/profile/transactions/transaction_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/profile/transactions/transaction_service.dart';

import 'model/transaction_model.dart';

class TransactionController extends GetxController {
  final TransactionService _service;
  TransactionController(this._service);

  final transactions = <ProfilePaymentTransaction>[].obs;
  final isLoading = true.obs;
  final RxMap<String, List<ProfilePaymentTransaction>> groupedTransactions =
      <String, List<ProfilePaymentTransaction>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      final list = await _service.fetchTransactions();
      // Sort by date descending before grouping
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      transactions.assignAll(list);
      _groupTransactions();
    } catch (e) {
      Get.snackbar('Error', 'Could not load transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _groupTransactions() {
    final groups = <String, List<ProfilePaymentTransaction>>{};
    for (final tx in transactions) {
      final dateString = tx.formattedDate; // Use helper from model
      if (groups.containsKey(dateString)) {
        groups[dateString]!.add(tx);
      } else {
        groups[dateString] = [tx];
      }
    }
    groupedTransactions.value = groups;
  }
}