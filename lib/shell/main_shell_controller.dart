import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/profile/transactions/transactions_screen.dart';
import 'package:grocer_ai/features/profile/transactions/transaction_details_screen.dart';

import '../core/theme/network/dio_client.dart';
import '../features/preferences/preferences_controller.dart';
import '../features/preferences/preferences_repository.dart';
import '../features/profile/preferences/views/preferences_screen.dart';
import '../features/profile/referrals/referral_binding.dart';
import '../features/profile/transactions/transaction_binding.dart';
import '../features/profile/views/my_referral_screen.dart';
import '../features/profile/views/referral_summary_screen.dart';

class MainShellController extends GetxController {
  /// which bottom tab is active
  final current = 0.obs;

  /// one Navigator per tab (0=Home,1=Offer,2=Orders,3=Help,4=Settings/Profile)
  final navKeys = List<GlobalKey<NavigatorState>>.generate(
    5,
        (_) => GlobalKey<NavigatorState>(),
  );

  void goTo(int index) {
    current.value = index;
  }

  /// Open the Transactions list INSIDE the Settings/Profile tab
  void openTransactions() {
    // make sure we’re looking at tab 4 (SettingsScreen = profile tab)
    goTo(4);

    // --- 2. MODIFY THIS NAVIGATION ---
    // Change MaterialPageRoute to GetPageRoute
    navKeys[4].currentState?.push(
      GetPageRoute(
        page: () => const TransactionsScreen(),
        binding: TransactionBinding(), // <-- This loads the controller
      ),
    );
  }
  /// (Optional helper) Open transaction detail directly,
  /// in case you ever need deep-linking into a specific transaction
  void openTransactionDetail(String transactionId) {
    goTo(4);

    navKeys[4].currentState?.push(
      MaterialPageRoute(
        // --- MODIFIED: Pass 'transactionId' to the screen ---
        builder: (_) => TransactionDetailScreen(transactionId: transactionId),
      ),
    );
  }

  void openReferral() {
    goTo(4);
    // --- 2. MODIFY THIS NAVIGATION ---
    navKeys[4].currentState?.push(
      GetPageRoute(
        page: () => const ReferralSummaryScreen(),
        binding: ReferralBinding(), // <-- ADD BINDING
      ),
    );
  }

  // --- NEW: open PreferencesScreen in the same tab stack ---
  void openPreferences() {
    // 1. Switch to the Profile tab (index 4 in your MainShell)
    goTo(4);

    // 2. Ensure the controller is registered exactly once
    if (!Get.isRegistered<PreferencesController>()) {
      // grab the shared DioClient from Get
      final dioClient = Get.find<DioClient>();

      // create the repo with that client
      final repo = PreferencesRepository(dioClient);

      // inject the controller that uses that repo
      Get.put<PreferencesController>(
        PreferencesController(repo),
        permanent: false,
      );
    }

    // 3. Push PreferencesScreen into the Profile tab's nested Navigator
    navKeys[4].currentState?.push(
      MaterialPageRoute(
        builder: (_) => const PreferencesScreen(),
      ),
    );
  }

  void openMyReferralList() {
    // 1. jump to Profile tab (index 4 in your shell)
    goTo(4);

    // --- THIS IS THE FIX ---
    // 2. push MyReferralScreen using GetPageRoute and its binding
    navKeys[4].currentState?.push(
      GetPageRoute(
        page: () => const MyReferralScreen(),
        binding: ReferralBinding(), // <-- This is the fix
      ),
    );
    // --- END FIX ---
  }
}