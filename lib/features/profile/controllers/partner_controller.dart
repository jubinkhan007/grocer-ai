// lib/features/profile/controllers/partner_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/partner_model.dart';
import '../models/partner_search_user.dart';
import '../services/partner_service.dart';

class PartnerController extends GetxController {
  PartnerController(this._service);
  final PartnerService _service;

  final partners = <Partner>[].obs;
  final isLoading = false.obs;

  final searchResults = <PartnerSearchUser>[].obs;
  final isSearching = false.obs;

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
    } catch (e) {
      debugPrint('loadPartners failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.trim().length < 2) {
      searchResults.clear();
      return;
    }
    try {
      isSearching.value = true;
      final list = await _service.searchUsers(query);
      searchResults.assignAll(list);
    } catch (e) {
      debugPrint('searchUsers failed: $e');
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<bool> addPartnerFromUser(PartnerSearchUser user) async {
    // Client-side guard: already added?
    if (partners.any((p) => p.partnerId == user.id)) {
      Get.snackbar('Partner', 'This partner is already added.');
      return false;
    }

    try {
      final created = await _service.addPartner(partnerId: user.id);
      if (created != null) {
        partners.add(created);
        Get.snackbar('Partner', 'Partner added successfully.');
        return true;
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map && data['non_field_errors'] is List)
          ? (data['non_field_errors'] as List).join('\n')
          : 'Unable to add partner.';
      Get.snackbar('Partner', msg);
    } catch (e) {
      debugPrint('addPartnerFromUser failed: $e');
      Get.snackbar('Partner', 'Unable to add partner.');
    }
    return false;
  }

  Future<void> removePartner(int relationId) async {
    try {
      await _service.removePartner(relationId);
      partners.removeWhere((p) => p.id == relationId);
    } catch (e) {
      debugPrint('removePartner failed: $e');
      Get.snackbar('Partner', 'Unable to remove partner.');
    }
  }

  void clearSearch() {
    searchResults.clear();
    isSearching.value = false;
  }
}
