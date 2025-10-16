import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../ui/theme/app_theme.dart';

class InviteFriendsSheet extends StatelessWidget {
  const InviteFriendsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    const referralCode = 'michale10';
    const referralLink = 'https://grocerai.app/referral/$referralCode';

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Invite friends',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                children: [
                  _socialButton(Icons.email, 'Email'),
                  _socialButton(Icons.facebook, 'Facebook'),
                  _socialButton(Icons.share, 'Twitter'),
                  _socialButton(Icons.link, 'LinkedIn'),
                  _socialButton(Icons.message, 'WhatsApp'),
                ],
              ),
              const SizedBox(height: 24),
              // --- Copy Row ---
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacings.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      referralCode,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            const ClipboardData(text: referralLink));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Referral link copied to clipboard!')),
                        );
                      },
                      child: const Icon(Icons.copy, color: AppColors.teal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Share Button ---
              ElevatedButton.icon(
                onPressed: () {
                  Share.share(
                    'Hey! Join GrocerAI and earn rewards. Use my code "$referralCode": $referralLink',
                    subject: 'Join me on GrocerAI',
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _socialButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.teal.withOpacity(0.1),
          child: Icon(icon, color: AppColors.teal),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
