import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../wallet/wallet_screen.dart';
import '../transactions/transactions_screen.dart';
import '../settings/settings_screen.dart';
import 'root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      WalletScreen(),        // Home / Wallet as per Figma
      TransactionsScreen(),  // Activity
      SettingsScreen(),      // Profile/More tab
    ];

    return Obx(() {
      return Scaffold(
        body: SafeArea(top: false, child: pages[controller.index.value]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.index.value,
          onTap: controller.setIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Activity'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
        backgroundColor: AppColors.bg,
      );
    });
  }
}
