import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/personal_info_model.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _service;
  ProfileController(this._service);

  final personalInfo = Rxn<PersonalInfo>();
  final isLoading = false.obs;

  Future<void> loadPersonalInfo() async {
    try {
      isLoading.value = true;
      final info = await _service.fetchPersonalInfo();
      if (info != null) {
        personalInfo.value = info;
      }
    } catch (e) {
      // Don’t crash the sheet.
      // Optional: you can log or store a fallback error state here.
      debugPrint('loadPersonalInfo() failed: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updatePersonalInfo(PersonalInfo updated, {bool partial = false}) async {
    try {
      isLoading.value = true;
      final updatedInfo = await _service.updatePersonalInfo(
        data: updated.toJson(),
        partial: partial,
      );
      if (updatedInfo != null) personalInfo.value = updatedInfo;
    } finally {
      isLoading.value = false;
    }
  }
}
