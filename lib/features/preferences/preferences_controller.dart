import 'package:get/get.dart';
import 'preferences_repository.dart';
import '../../core/theme/network/error_mapper.dart';

class PreferencesController extends GetxController {
  final PreferencesRepository repo;
  PreferencesController(this.repo);

  // Entire list from API
  final items = <PreferenceItem>[].obs;

  // ---------- Helpers to find existing prefs by title ----------
  String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  PreferenceItem? _byTitleContainsAny(List<String> qs) {
    for (final q in qs) {
      final qn = _norm(q);
      final hit = items.firstWhereOrNull((e) => _norm(e.title).contains(qn));
      if (hit != null) return hit;
    }
    return null;
  }

  // Map EXACTLY what your backend has today
  PreferenceItem? get grocers =>
      _byTitleContainsAny(['Nearby Grocers']);
  PreferenceItem? get house =>
      _byTitleContainsAny(['Confirm your household']);
  PreferenceItem? get diet =>
      _byTitleContainsAny(['Dietary Preference']);
  PreferenceItem? get cuisine =>
      _byTitleContainsAny(['Cuisine Preferences']);
  PreferenceItem? get frequency =>
      _byTitleContainsAny(['Confirm your shopping frequency']);
  PreferenceItem? get budget =>
      _byTitleContainsAny(['Spending limit per week']);
  // The API uses misspelled "alergies"
  PreferenceItem? get allergies =>
      _byTitleContainsAny(['alergies', 'allergies']);

  // ---------- Local UI state ----------
  // grocers
  final selectedGrocerIds = <int>{}.obs; // UI may limit to 3

  // household numbers keyed by option id
  final householdCounts = <int, int>{}.obs; // {optionId: count}
  RxInt adultCount = 0.obs;
  RxInt kidCount = 0.obs;
  RxInt petCount = 0.obs;

  // diet & cuisine
  final selectedDietIds = <int>{}.obs;
  final selectedCuisineIds = <int>{}.obs;
  final dietNote = ''.obs;
  final cuisineNote = ''.obs;

  // frequency (single)
  final selectedFrequencyId = RxnInt();

  // budget (single from range options)
  final selectedBudgetId = RxnInt();

  // edit / view
  final isEditing = false.obs;

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

      // initialize household counters from option.number_value
      initHouseholdCounts();
      for (final o in (house?.options ?? const [])) {
        if (o.numberValue != null) householdCounts[o.id] = o.numberValue!;
      }
    } on ApiFailure catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      loading.value = false;
    }
  }

  // ---------- Household helpers ----------
  PreferenceItem? get household => house;

  void initHouseholdCounts() {
    final pref = house;
    if (pref == null) return;

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

  // ------------------- Submit helpers per section -------------------

  Future<bool> submitGrocers({bool enforce = true}) async {
    final pref = grocers;
    if (pref == null) return true;

    final ids = selectedGrocerIds.toList();
    if (ids.isEmpty) {
      // Only show the mandatory warning if we're explicitly enforcing it
      if (enforce && pref.isMandatory) {
        Get.snackbar('Save failed', 'Please select at least one option for "${pref.title}".');
        return false;
      }
      return true; // silently skip if not enforcing (e.g., section hidden)
    }

    await _safePost(UserPrefPayload(preference: pref.id, selectedOptions: ids));
    return true;
  }

  Future<bool> submitHousehold() async {
    final pref = house;
    if (pref == null) return true;
    syncHouseholdMap();

    // Post each numeric option + value sequentially
    for (final entry in householdCounts.entries) {
      final ok = await _safePost(UserPrefPayload(
        preference: pref.id,
        selectedOption: entry.key,
        numberValue: entry.value.toString(),
      ));
      if (!ok) return false;
    }
    return true;
  }

  Future<bool> submitDiet() async {
    final pref = diet;
    if (pref == null) return true;
    final ids = selectedDietIds.toList();
    if (ids.isEmpty) {
      if (pref.isMandatory) {
        Get.snackbar('Save failed',
            'Please select at least one option for "${pref.title}".');
        return false;
      }
      return true;
    }
    return await _safePost(UserPrefPayload(
      preference: pref.id,
      selectedOptions: ids,
      additionInfo: dietNote.value.trim().isEmpty ? null : dietNote.value.trim(),
    ));
  }

  Future<bool> submitCuisine() async {
    final pref = cuisine;
    if (pref == null) return true;
    final ids = selectedCuisineIds.toList();
    if (ids.isEmpty) {
      if (pref.isMandatory) {
        Get.snackbar('Save failed',
            'Please select at least one option for "${pref.title}".');
        return false;
      }
      return true;
    }
    return await _safePost(UserPrefPayload(
      preference: pref.id,
      selectedOptions: ids,
      additionInfo:
      cuisineNote.value.trim().isEmpty ? null : cuisineNote.value.trim(),
    ));
  }

  Future<bool> submitFrequency() async {
    final pref = frequency;
    if (pref == null) return true;
    final sel = selectedFrequencyId.value;
    if (sel == null) {
      if (pref.isMandatory) {
        Get.snackbar('Save failed', 'Please select one option for "${pref.title}".');
        return false;
      }
      return true;
    }
    return await _safePost(UserPrefPayload(preference: pref.id, selectedOption: sel));
  }

  /// Budget (num_rng) — send selected option id
  Future<bool> submitBudget() async {
    final pref = budget;
    if (pref == null) return true;
    final sel = selectedBudgetId.value;
    if (sel == null) {
      if (pref.isMandatory) {
        Get.snackbar('Save failed', 'Please choose a budget range.');
        return false;
      }
      return true;
    }
    return await _safePost(
        UserPrefPayload(preference: pref.id, selectedOption: sel));
  }

  Future<bool> submitAllergies() async {
    final pref = allergies;
    if (pref == null) return true; // section isn't in API → nothing to do
    final ids = selectedAllergyIds.toList();
    if (ids.isEmpty) {
      // Allergies aren't mandatory per your API; skip silently
      return true;
    }
    return await _safePost(
      UserPrefPayload(preference: pref.id, selectedOptions: ids),
    );
  }
  // Backing store for allergies selections
  final _selectedAllergyIds = <int>{}.obs;
  Set<int> get selectedAllergyIds => _selectedAllergyIds;

  // ---------------------------------------------------------------
  /// Post and convert exceptions to bool so callers can make a single toast.
  Future<bool> _safePost(UserPrefPayload payload) async {
    try {
      await repo.postUserPreference(payload);
      return true;
    } on ApiFailure catch (e) {
      Get.snackbar('Save failed', e.message);
      return false;
    }
  }
}
