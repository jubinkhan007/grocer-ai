import 'package:flutter/material.dart';

import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/ff_app_bar.dart';
import '../../../ui/widgets/section_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FFAppBar(title: 'Your Wallet'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available Balance', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                Text('\$1,289.20', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Add money'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Withdraw'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
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
                  style: TextStyle(color: i.isEven ? AppColors.success : AppColors.text, fontWeight: FontWeight.w600),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
