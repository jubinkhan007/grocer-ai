// lib/features/profile/wallet/wallet_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/profile/models/wallet_model.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_service.dart';

class WalletController extends GetxController {
  final WalletService _service;
  WalletController(this._service);

  final wallet = Rxn<Wallet>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadWallet();
  }

  Future<void> loadWallet() async {
    try {
      isLoading.value = true;
      wallet.value = await _service.fetchWallet();
    } catch (e) {
      Get.snackbar('Error', 'Could not load wallet details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}