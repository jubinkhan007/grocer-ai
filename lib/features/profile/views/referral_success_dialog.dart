import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';

class ReferralSuccessDialog extends StatelessWidget {
  const ReferralSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/referral_money.png', height: 140),
          const SizedBox(height: 16),
          const Text(
            'Congratulations!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have just earned \$50.\nInvite more friends to earn more!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal, minimumSize: const Size(200, 44)),
            child: const Text('Invite another'),
          )
        ],
      ),
    );
  }
}
