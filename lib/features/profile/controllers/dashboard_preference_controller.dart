import 'package:get/get.dart';
import '../models/dashboard_preference_model.dart';
import '../services/dashboard_preference_service.dart';

class DashboardPreferenceController extends GetxController {
  DashboardPreferenceController(this._service);
  final DashboardPreferenceService _service;

  final prefs = Rxn<DashboardPreference>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    try {
      isLoading.value = true;
      prefs.value = await _service.fetchPreferences();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePref(String key, bool value) async {
    if (prefs.value == null) return;
    final data = prefs.value!.toJson();
    data[key] = value;
    prefs.value = DashboardPreference.fromJson(data);
    await _service.updatePreferences(data);
    prefs.refresh();
  }
}
