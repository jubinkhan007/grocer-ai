// lib/features/preferences/preferences_controller.dart
import 'package:get/get.dart';
import 'preferences_repository.dart';
import '../../core/theme/network/error_mapper.dart';

class PreferencesController extends GetxController {
  final PreferencesRepository repo;
  PreferencesController(this.repo);

  // Entire list from API
  final items = <PreferenceItem>[].obs;

  // Quick accessors by title (stable text from your mocks)
  PreferenceItem? get grocers => _byTitleContains('Nearby Grocers');
  PreferenceItem? get house => _byTitleContains('Confirm your household');
  PreferenceItem? get diet => _byTitleContains('Dietary');
  PreferenceItem? get cuisine => _byTitleContains('Cuisine');
  PreferenceItem? get frequency => _byTitleContains('frequency');
  PreferenceItem? get budget => _byTitleContains('Spending limit');
  PreferenceItem? get allergy => _byTitleContains('alerg');
  PreferenceItem? get comfort   => _byTitleContains('comfort level');
  PreferenceItem? _byTitleContains(String q) => items.firstWhereOrNull(
    (e) => e.title.toLowerCase().contains(q.toLowerCase()),
  );

  // ---------- Local UI state ----------
  // grocers
  final selectedGrocerIds = <int>{}.obs; // limit UI to 3 in the view

  // household (we store values keyed by option id)
  final householdCounts = <int, int>{}.obs; // {optionId: count}

  // diet & cuisine
  final selectedDietIds = <int>{}.obs;
  final selectedCuisineIds = <int>{}.obs;
  final dietNote = ''.obs;
  final cuisineNote = ''.obs;
  // ------------------- Household reactive counters -------------------
  RxInt adultCount = 0.obs;
  RxInt kidCount = 0.obs;
  RxInt petCount = 0.obs;
  // editing mode (false = view mode like left screenshot, true = edit mode like right screenshot)
  final isEditing = false.obs;
  final comfortLevel = 'Intermediate'.obs; // default shown in view mode

  // Getter for convenience (UI layer uses `controller.household`)
  PreferenceItem? get household => house;

  // Keep them in sync with the option IDs
  void initHouseholdCounts() {
    final pref = house;
    if (pref == null) return;

    // reset
    adultCount.value = 0;
    kidCount.value = 0;
    petCount.value = 0;

    for (final o in pref.options) {
      final label = (o.label ?? '').toLowerCase();
      if (label.contains('adult')) {
        adultCount.value = o.numberValue ?? 0;
        householdCounts[o.id] = adultCount.value;
      } else if (label.contains('kid')) {
        kidCount.value = o.numberValue ?? 0;
        householdCounts[o.id] = kidCount.value;
      } else if (label.contains('pet')) {
        petCount.value = o.numberValue ?? 0;
        householdCounts[o.id] = petCount.value;
      }
    }
  }

  // Whenever user increments/decrements, reflect to map
  void syncHouseholdMap() {
    final pref = house;
    if (pref == null) return;

    for (final o in pref.options) {
      final label = (o.label ?? '').toLowerCase();
      if (label.contains('adult')) {
        householdCounts[o.id] = adultCount.value;
      } else if (label.contains('kid')) {
        householdCounts[o.id] = kidCount.value;
      } else if (label.contains('pet')) {
        householdCounts[o.id] = petCount.value;
      }
    }
  }

  // frequency (single)
  final selectedFrequencyId = RxnInt();

  // budget (single chip OR custom text)
  final selectedBudgetId = RxnInt(); // when user taps a chip
  final customBudgetText = ''.obs; // when they type in the field

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      items.assignAll(await repo.fetchAll());
      initHouseholdCounts();
      // prime householdCounts from defaults if provided
      for (final o in (house?.options ?? const [])) {
        if (o.numberValue != null) householdCounts[o.id] = o.numberValue!;
      }
    } on ApiFailure catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      loading.value = false;
    }
  }

  // ------------------- Submit helpers per screen -------------------

  Future<void> submitGrocers() async {
    final pref = grocers;
    if (pref == null) return;
    await _safePost(
      UserPrefPayload(
        preference: pref.id,
        selectedOptions: selectedGrocerIds.toList(),
      ),
    );
  }

  Future<void> submitHousehold() async {
    final pref = house;
    if (pref == null) return;

    syncHouseholdMap(); // ensure latest numbers before saving

    for (final entry in householdCounts.entries) {
      await _safePost(
        UserPrefPayload(
          preference: pref.id,
          selectedOption: entry.key,
          numberValue: entry.value.toString(),
        ),
      );
    }
  }

  Future<void> submitDiet() async {
    final pref = diet;
    if (pref == null) return;
    await _safePost(
      UserPrefPayload(
        preference: pref.id,
        selectedOptions: selectedDietIds.toList(),
        additionInfo: dietNote.isEmpty ? null : dietNote.value,
      ),
    );
  }

  Future<void> submitCuisine() async {
    final pref = cuisine;
    if (pref == null) return;
    await _safePost(
      UserPrefPayload(
        preference: pref.id,
        selectedOptions: selectedCuisineIds.toList(),
        additionInfo: cuisineNote.isEmpty ? null : cuisineNote.value,
      ),
    );
  }

  Future<void> submitFrequency() async {
    final pref = frequency;
    if (pref == null || selectedFrequencyId.value == null) return;
    await _safePost(
      UserPrefPayload(
        preference: pref.id,
        selectedOption: selectedFrequencyId.value,
      ),
    );
  }

  Future<void> submitBudget() async {
    final pref = budget;
    if (pref == null) return;
    // If user picked a chip → selectedOption; else the free-text goes into number_value/addition_info
    if (selectedBudgetId.value != null) {
      await _safePost(
        UserPrefPayload(
          preference: pref.id,
          selectedOption: selectedBudgetId.value,
        ),
      );
    } else {
      await _safePost(
        UserPrefPayload(
          preference: pref.id,
          numberValue: customBudgetText.value.trim().isEmpty
              ? null
              : customBudgetText.value.trim(),
        ),
      );
    }
  }

  Future<void> submitComfortLevel() async {
    final pref = comfort;
    if (pref == null) return;

    // The comfort level chips ("Beginner", "Intermediate", "Advanced")
    // aren't currently wired to IDs in this controller.
    // We store the chosen string in comfortLevel.value.
    //
    // We'll send that as free-form text via additionInfo.
    await _safePost(
      UserPrefPayload(
        preference: pref.id,
        additionInfo: comfortLevel.value,
      ),
    );
  }

  // ---------------------------------------------------------------
  Future<void> _safePost(UserPrefPayload payload) async {
    try {
      await repo.postUserPreference(payload);
    } on ApiFailure catch (e) {
      Get.snackbar('Save failed', e.message);
      rethrow;
    }
  }
}
