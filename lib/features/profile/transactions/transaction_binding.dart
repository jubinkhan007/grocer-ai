// lib/features/profile/transactions/transaction_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/profile/transactions/transaction_controller.dart';
import 'package:grocer_ai/features/profile/transactions/transaction_service.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionService(Get.find<DioClient>()), fenix: true);
    Get.lazyPut(() => TransactionController(Get.find<TransactionService>()),
        fenix: true);
  }
}