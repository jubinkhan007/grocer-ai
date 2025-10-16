import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';
import 'referral_list_screen.dart';

class ReferralSummaryScreen extends StatelessWidget {
  const ReferralSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refer your friends')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/referral_coins.png', height: 160)),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Earn \$189 each',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.teal),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacings.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Referral code'),
                      SizedBox(height: 4),
                      Text('michale10',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Copy'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReferralListScreen(),
                    ),
                  );
                },
                child: const Text('My referral'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
