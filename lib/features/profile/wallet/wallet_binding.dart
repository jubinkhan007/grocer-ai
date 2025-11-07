// lib/features/profile/wallet/wallet_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_controller.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_service.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletService(Get.find<DioClient>()));
    Get.lazyPut(() => WalletController(Get.find<WalletService>()));
  }
}