// lib/features/profile/controllers/referral_summary_controller.dart
import 'package:get/get.dart';
import 'package:grocer_ai/features/profile/models/faq_model.dart';
import 'package:grocer_ai/features/profile/models/flow_step_model.dart';
import 'package:grocer_ai/features/profile/services/referral_summary_service.dart';
import 'package:grocer_ai/features/profile/wallet/wallet_controller.dart';

import '../../../core/auth/current_user_service.dart';

class ReferralSummaryController extends GetxController {
  final ReferralSummaryService _service;
  final WalletController walletController; // Inject WalletController
  final CurrentUserService currentUser;

  ReferralSummaryController(this._service, this.walletController, this.currentUser,);

  final steps = <FlowStep>[].obs;
  final faqs = <Faq>[].obs;

  final isLoadingSteps = true.obs;
  final isLoadingFaqs = true.obs;

  // Track the currently expanded FAQ. -1 means all are closed.
  final expandedFaqIndex = 0.obs; // Default to first item expanded
  // Exposed referral code from JWT
  late final String referralCode;
  @override
  void onInit() {
    super.onInit();
    referralCode = currentUser.referralCode ?? '';
    loadSteps();
    loadFaqs();
    // WalletController is already loaded via AppBindings,
    // so we can just use it.
  }

  Future<void> loadSteps() async {
    try {
      isLoadingSteps.value = true;
      final stepList = await _service.fetchFlowSteps();
      // Sort by serial number to ensure correct order
      stepList.sort((a, b) => a.serialNumber.compareTo(b.serialNumber));
      steps.assignAll(stepList);
    } catch (e) {
      Get.snackbar('Error', 'Could not load referral steps.');
    } finally {
      isLoadingSteps.value = false;
    }
  }

  Future<void> loadFaqs() async {
    try {
      isLoadingFaqs.value = true;
      faqs.assignAll(await _service.fetchFaqs());
    } catch (e) {
      Get.snackbar('Error', 'Could not load FAQs.');
    } finally {
      isLoadingFaqs.value = false;
    }
  }

  void toggleFaq(int index) {
    if (expandedFaqIndex.value == index) {
      expandedFaqIndex.value = -1; // Close if already open
    } else {
      expandedFaqIndex.value = index;
    }
  }
}