import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shell/main_shell_controller.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/ff_app_bar.dart';
import '../../../ui/widgets/section_card.dart';
import '../../../ui/widgets/setting_row.dart';
import '../../preferences/preferences_binding.dart';
import '../preferences/views/preferences_screen.dart';
import '../reviews/reviews_screen.dart';
import '../invite/invite_screen.dart';
import '../security/views/security_screen.dart';
import '../views/about_us_screen.dart';
import '../views/dashboard_preference_sheet.dart';
import '../views/logout_dialog.dart';
import '../views/personal_info_sheet.dart';
import '../views/terms_conditions_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FFAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            SectionCard(
              child: Row(
                children: [
                  const CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/avatar_placeholder.png')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Michael Anderson', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text('Gold member', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('1,280 pts', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SettingRow(
              title: 'Personal information',
              onTap: () => _showPersonalInfoSheet(context),
            ),
            const Divider(height: 1),
            // Menu list one
            SectionCard(
              child: Column(
                children: [
                  SettingRow(title: 'Wallet', onTap: () => Get.toNamed('/profile/wallet')),
                  const Divider(height: 1),
                  SettingRow(
                    title: 'Transactions',
                    onTap: () {
                      final shell = Get.find<MainShellController>();
                      shell.openTransactions();
                    },
                  ),
                  const Divider(height: 1),
                  SettingRow(title: 'Live chat', onTap: () => Get.toNamed('/profile/livechat')),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Menu list two
            SectionCard(
              child: Column(
                children: [
                  SettingRow(title: 'Reviews & Rating', onTap: () => Get.to(() => const ReviewsScreen())),
                  const Divider(height: 1),
                  SettingRow(title: 'Invite friends', onTap: () => Get.to(() => const InviteScreen())),
                  const Divider(height: 1),
                  SettingRow(
                    title: 'Preferences',
                    onTap: () {
                      final shell = Get.find<MainShellController>();
                      shell.openPreferences();
                    },
                  ),

                  const Divider(height: 1),
                  SettingRow(
                    title: 'Dashboard Preferences',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const DashboardPreferenceSheet(),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingRow(title: 'Security', onTap: () => Get.to(() => const SecurityScreen())),
                  const Divider(height: 1),
                  SettingRow(
                    title: 'About Us',
                    onTap: () => Get.to(() => const AboutUsScreen()),
                  ),
                  const Divider(height: 1),
                  SettingRow(
                    title: 'Terms & Conditions',
                    onTap: () => Get.to(() => const TermsConditionsScreen()),
                  ),
                  const Divider(height: 1),
                  SettingRow(title: 'Help & Support', onTap: () => Get.toNamed('/support')),
                  const Divider(height: 1),
                  SettingRow(
                    title: 'Logout',
                    onTap: () => showLogoutDialog(context),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showPersonalInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const PersonalInfoSheet(),
    );
  }

}
