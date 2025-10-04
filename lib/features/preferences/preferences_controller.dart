// lib/features/preferences/preferences_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';
import 'package:grocer_ai/features/preferences/preferences_repository.dart';

const kTopTeal = 0xFF0C3E3D;
const kPageBg = 0xFFF1F4F6;

class PreferencesController extends GetxController {
  final PreferencesRepository repo;
  PreferencesController(this.repo);

  // OPTIONS
  final options = Rxn<PrefOptions>();
  final loading = true.obs;
  final error = RxnString();

  // STATE
  final selectedGrocers = <String>[].obs;
  final adults = 0.obs;
  final kids = 0.obs;
  final pets = 0.obs;

  final dietSelected = <String>[].obs;
  final dietNote = ''.obs;

  final cuisineSelected = <String>[].obs;
  final cuisineNote = ''.obs;

  final frequency = ''.obs;
  final budget = ''.obs; // either chip text or custom field

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      loading.value = true;
      error.value = null;
      final opt = await repo.load();
      options.value = opt;
      adults.value = opt.defaultAdults;
      kids.value = opt.defaultKids;
      pets.value = opt.defaultPets;
    } on ApiFailure catch (e) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  }

  bool toggleGrocer(String id) {
    if (selectedGrocers.contains(id)) {
      selectedGrocers.remove(id);
      return true;
    }
    final max = options.value?.grocerMax ?? 3;
    if (selectedGrocers.length >= max) return false;
    selectedGrocers.add(id);
    return true;
  }

  Future<void> submit() async {
    final opt = options.value;
    if (opt == null) return;

    final payload = PrefPayload(
      grocers: selectedGrocers.toList(),
      adults: adults.value,
      kids: kids.value,
      pets: pets.value,
      diet: dietSelected.toList(),
      cuisine: cuisineSelected.toList(),
      frequency: frequency.value.isEmpty
          ? (opt.frequency.isNotEmpty ? opt.frequency.last : '')
          : frequency.value,
      budget: budget.value.isEmpty
          ? (opt.budgets.isNotEmpty ? opt.budgets.first : '')
          : budget.value,
      dietNote: dietNote.value.isEmpty ? null : dietNote.value,
      cuisineNote: cuisineNote.value.isEmpty ? null : cuisineNote.value,
    );

    try {
      loading.value = true;
      await repo.submit(payload);
      Get.back(); // or navigate to Home
    } on ApiFailure catch (e) {
      Get.snackbar('Save failed', e.message);
    } finally {
      loading.value = false;
    }
  }
}
