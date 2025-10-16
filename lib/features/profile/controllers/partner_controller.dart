import 'package:get/get.dart';
import '../models/partner_model.dart';
import '../services/partner_service.dart';

class PartnerController extends GetxController {
  PartnerController(this._service);

  final PartnerService _service;

  final partners = <Partner>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPartners();
  }

  Future<void> loadPartners() async {
    try {
      isLoading.value = true;
      final list = await _service.fetchPartners();
      partners.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPartner(String name) async {
    final newPartner = await _service.addPartner(name);
    if (newPartner != null) {
      partners.add(newPartner);
    }
  }

  Future<void> removePartner(int id) async {
    await _service.deletePartner(id);
    partners.removeWhere((p) => p.id == id);
  }
}
