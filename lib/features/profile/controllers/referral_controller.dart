import 'package:get/get.dart';
import '../models/referral_model.dart';
import '../services/referral_service.dart';

class ReferralController extends GetxController {
  ReferralController(this._service);

  final ReferralService _service;
  final referrals = <Referral>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReferrals();
  }

  Future<void> loadReferrals() async {
    try {
      isLoading.value = true;
      final list = await _service.fetchReferrals();
      referrals.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addReferral(Map<String, dynamic> data) async {
    final newRef = await _service.addReferral(data);
    if (newRef != null) referrals.add(newRef);
  }

  Future<void> removeReferral(int id) async {
    await _service.deleteReferral(id);
    referrals.removeWhere((r) => r.id == id);
  }
}
