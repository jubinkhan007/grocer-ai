// lib/features/profile/wallet/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- 1. ADD
import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/ff_app_bar.dart';
import '../../../ui/widgets/section_card.dart';
import 'wallet_controller.dart'; // <-- 2. ADD

// 3. CHANGE to GetView<WalletController>
class WalletScreen extends GetView<WalletController> {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FFAppBar(title: 'Your Wallet'),
      // 4. ADD Obx to handle loading and data states
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wallet.value == null) {
          return const Center(child: Text('Could not load wallet data.'));
        }

        // Get the wallet data from the controller
        final wallet = controller.wallet.value!;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available Balance',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  // 5. REPLACE hardcoded text with dynamic data
                  Text(
                    '\$${wallet.usableBalance}', // <-- Use usableBalance from API
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.snackbar('Coming Soon',
                                'Add money flow not implemented.');
                          },
                          child: const Text('Add money'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.snackbar('Coming Soon',
                                'Withdraw flow not implemented.');
                          },
                          child: const Text('Withdraw'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Recent activity',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // NOTE: The "Recent activity" list remains static for now,
            // as the /api/v1/profile/wallet/ endpoint does not return transactions.
            // This list will be populated by the TransactionController.
            ...List.generate(8, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppSpacings.r),
                ),
                child: ListTile(
                  title: Text(i.isEven ? 'Deposit' : 'Purchase'),
                  subtitle: const Text('Today • 10:20 AM'),
                  trailing: Text(
                    i.isEven ? '+\$40.00' : '-\$12.99',
                    style: TextStyle(
                        color: i.isEven ? AppColors.success : AppColors.text,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}