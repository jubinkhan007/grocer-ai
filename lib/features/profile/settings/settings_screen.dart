import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../shell/main_shell_controller.dart';
import '../controllers/profile_controller.dart';
import '../security/views/security_screen.dart';
import '../views/about_us_screen.dart';
import '../views/dashboard_preference_sheet.dart';
import '../views/logout_dialog.dart';
import '../views/personal_info_sheet.dart';
import '../views/terms_conditions_screen.dart';

/// ===== FIGMA TOKENS =========================================================

const _pageBg = Color(0xFFF4F6F6); // screen background
const _statusTeal = Color(0xFF002C2E); // very top status strip
const _headerTeal = Color(0xFF33595B); // teal block behind avatar/info
const _tileBg = Color(0xFFFEFEFE); // tiles + credit card bg
const _tileBorder = Color(0xFFE6EAEB); // credit card border
const _textPrimary = Color(0xFF212121); // "$189"
const _textSecondary = Color(0xFF4D4D4D); // "Total credit", tile labels
const _textOnTealPrimary = Color(0xFFFEFEFE); // name text on teal
const _textOnTealSecondary = Color(0xFFE6EAEB); // email text on teal
const _chipGrey = Color(0xFFB0BFBF); // small round arrow button
const _avatarBadgeBg = Color(0xFFE6EAEB); // camera badge bg
const _bottomNavShadow = Color(0x2833595B); // upward shadow under nav

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Light status icons over dark teal strip.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _headerTeal,  // Same teal color for the status bar
      statusBarIconBrightness: Brightness.light,  // Ensure icons are white on teal
      statusBarBrightness: Brightness.dark,  // iOS handling
    ));

    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: _pageBg,
      //bottomNavigationBar: const _BottomNavBar(),
      body: Column(
        children: [
          _StatusStrip(paddingTop: media.padding.top),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: 24 + media.padding.bottom + 72,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header block (teal + avatar/name/email + credit card)
                  const _ProfileHeader(),

                  // Figma math:
                  // header stack ends visually at y=267,
                  // first tile list starts at y=281,
                  // → ~14px gap, NOT 62.
                  const SizedBox(height: 14),

                  // Settings tiles (each tile = white card radius 8, 16 padding)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _SettingsTile(
                          label: 'Personal information',
                          leading: Icons.person_outline,
                          onTap: () => _showPersonalInfoSheet(context),
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Partner',
                          leading: Icons.group_outlined,
                          onTap: () {
                            // TODO: hook up Partner nav when available
                          },
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Preferences',
                          leading: Icons.settings_outlined,
                          onTap: () {
                            final shell = Get.find<MainShellController>();
                            shell.openPreferences();
                          },
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Dashboard Preference',
                          leading: Icons.dashboard_customize_outlined,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const DashboardPreferenceSheet(),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Security',
                          leading: Icons.lock_outline,
                          onTap: () => Get.to(() => const SecurityScreen()),
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Transaction',
                          leading: Icons.sync_alt_rounded,
                          onTap: () {
                            final shell = Get.find<MainShellController>();
                            shell.openTransactions();
                          },
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Referral',
                          // Figma uses a little node/graph icon. We’ll
                          // approximate with share_outlined.
                          leading: Icons.share_outlined,
                          onTap: () {
                            final shell = Get.find<MainShellController>();
                            shell.openReferral();
                          },
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'About Us',
                          leading: Icons.info_outline,
                          onTap: () => Get.to(() => const AboutUsScreen()),
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Terms & Conditions',
                          leading: Icons.description_outlined,
                          onTap: () =>
                              Get.to(() => const TermsConditionsScreen()),
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Help & support',
                          leading: Icons.help_outline,
                          onTap: () => Get.toNamed('/support'),
                        ),
                        const SizedBox(height: 16),
                        _SettingsTile(
                          label: 'Logout',
                          leading: Icons.logout,
                          onTap: () => showLogoutDialog(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  static void _showPersonalInfoSheet(BuildContext context) {
    final controller = Get.find<ProfileController>();

    // Kick off the network request. If it fails, we just log.
    controller.loadPersonalInfo();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // sheet draws its own bg/radius
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => const PersonalInfoSheet(),
    );
  }

}

/// DARK STATUS BAR STRIP (48px total height in the Figma artboard)
class _StatusStrip extends StatelessWidget {
  final double paddingTop;
  const _StatusStrip({required this.paddingTop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _statusTeal,
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: 12,
        left: 24,
        right: 24,
      ),
      // We let iOS/Android draw the actual clock/signal/battery.
    );
  }
}

/// HEADER AREA UNDER THE STATUS STRIP
///
/// Matches the Figma stack:
/// - teal rectangle (170 high)
/// - avatar row at top: avatar 72x72 on the left, name/email on the right
///   (name 20/700 white, email 16/400 #E6EAEB)
/// - camera badge hugging avatar bottom-right (16px icon, light bg)
/// - white credit card with border 1px #E6EAEB, radius 8,
///   "Total credit" / "$189", arrow chip on the right,
///   faint watermark coin.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 219, // exactly from Figma export
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // teal background block height 170
          Positioned.fill(
            top: 0,
            bottom: 219 - 170, // leaves ~49px of space below teal
            child: Container(color: _headerTeal),  // Ensure this matches the status bar color
          ),

          // Avatar + name + email row (left-aligned, not centered)
          Positioned(
            left: 24,
            right: 24,
            top: 25,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with camera badge overlay
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 72 x 72 circular avatar
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile_avatar.png',  // <-- put your real asset here
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Camera badge at bottom-right corner of avatar
                    Positioned(
                      right: -3,
                      bottom: -3,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _avatarBadgeBg,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          size: 16,
                          color: _headerTeal,  // same teal color for the camera badge
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Text column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Michael Anderson',
                        style: TextStyle(
                          color: _textOnTealPrimary,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'm.anderson@gmail.com',
                        style: TextStyle(
                          color: _textOnTealSecondary,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CREDIT CARD TILE
          Positioned(
            left: 24,
            right: 24,
            top: 129,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _tileBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _tileBorder,
                  width: 1,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 48x48 "coin" placeholder (yellow $ icon from Figma)
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Icon(
                            Icons.attach_money,
                            size: 32,
                            color: const Color(0xFFFFC107), // gold-ish
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // "Total credit" + "$189"
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Total credit',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$189',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Grey round arrow chip (30x30, radius 15)
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _chipGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.north_east,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // faint watermark coin (opacity 0.04, rotated)
                  Positioned(
                    left: 189,
                    top: 35,
                    child: Opacity(
                      opacity: 0.04,
                      child: Transform.rotate(
                        angle: -0.70, // ~-40°
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.monetization_on,
                            size: 48,
                            color: _headerTeal, // make sure this matches
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// SETTINGS TILE
///
/// White card, radius 8, padding 16, teal leading icon, label 14 / 500 / #4D4D4D.
class _SettingsTile extends StatelessWidget {
  final String label;
  final IconData leading;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.label,
    required this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _tileBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                leading,
                size: 20,
                color: _headerTeal, // dark teal icon like Figma
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              // No chevron in provided Figma.
            ],
          ),
        ),
      ),
    );
  }
}

/// BOTTOM NAV BAR
///
/// White background, upward shadow, 5 evenly spaced items.
/// Active item "Profile" gets teal color and fontWeight 500.
/// Others are grey (#4D4D4D).
// class _BottomNavBar extends StatelessWidget {
//   const _BottomNavBar();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 72,
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       decoration: const BoxDecoration(
//         color: _tileBg,
//         boxShadow: [
//           BoxShadow(
//             color: _bottomNavShadow,
//             blurRadius: 12,
//             offset: Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: const [
//           _BottomNavItem(
//             label: 'Home',
//             icon: Icons.home_outlined,
//             active: false,
//           ),
//           _BottomNavItem(
//             label: 'Offer',
//             icon: Icons.settings_applications_outlined,
//             active: false,
//           ),
//           _BottomNavItem(
//             label: 'Order',
//             icon: Icons.shopping_bag_outlined,
//             active: false,
//           ),
//           _BottomNavItem(
//             label: 'Help',
//             icon: Icons.help_outline,
//             active: false,
//           ),
//           _BottomNavItem(
//             label: 'Profile',
//             icon: Icons.person_outline,
//             active: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _BottomNavItem extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool active;
//
//   const _BottomNavItem({
//     required this.label,
//     required this.icon,
//     required this.active,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final color = active ? _headerTeal : _textSecondary;
//     final fontWeight = active ? FontWeight.w500 : FontWeight.w400;
//
//     return Expanded(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: () {
//           // hook up shell nav if needed
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 24, color: color),
//               const SizedBox(height: 6),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontFamily: 'Roboto',
//                   fontWeight: fontWeight,
//                   color: color,
//                   height: 1.3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
