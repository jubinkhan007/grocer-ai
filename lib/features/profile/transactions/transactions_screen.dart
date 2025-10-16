import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/ff_app_bar.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FFAppBar(title: 'Transactions'),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemBuilder: (_, i) => ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacings.r)),
          tileColor: AppColors.card,
          title: Text('Order #10${40 + i}'),
          subtitle: const Text('Visa •••• 1432 • 21 Aug'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('\$24.50', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('Paid', style: TextStyle(color: AppColors.success, fontSize: 12)),
            ],
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: 12,
      ),
    );
  }
}
