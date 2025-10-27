// lib/shell/main_shell.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/help/views/help_support_screen.dart';
import 'package:grocer_ai/features/orders/views/orders_screen.dart';
import 'package:grocer_ai/features/profile/settings/settings_screen.dart';
import 'package:grocer_ai/features/offer/views/offer_screen.dart';
import 'package:grocer_ai/ui/theme/app_theme.dart';
import 'package:grocer_ai/widgets/ff_bottom_nav.dart';
import 'main_shell_controller.dart';

// tab roots
import 'package:grocer_ai/features/home/dashboard_screen.dart';

class MainShell extends StatelessWidget {
  MainShell({super.key, int? initialIndex}) {
    // ensure the controller exists
    final c = Get.put(MainShellController(), permanent: true);

    // If you navigate here with an initial index, set it once.
    if (initialIndex != null) {
      c.goTo(initialIndex);
    }
  }

  final MainShellController _ctrl = Get.find<MainShellController>();

  @override
  Widget build(BuildContext context) {
    // Root pages for each bottom tab index
    final pages = <Widget>[
      const DashboardScreen(),       // 0
      const OfferScreen(),           // 1
      const OrderScreen(),           // 2
      const HelpSupportScreen(),     // 3
      const SettingsScreen(),        // 4  (this is your Profile screen)
    ];

    return Obx(() {
      final i = _ctrl.current.value;

      return WillPopScope(
        onWillPop: () async {
          // First try: pop the current tab's own navigator
          final canPop = _ctrl.navKeys[i].currentState?.canPop() ?? false;
          if (canPop) {
            _ctrl.navKeys[i].currentState?.pop();
            return false;
          }

          // If we're not on the home tab (0), go home instead of exiting
          if (i != 0) {
            _ctrl.goTo(0);
            return false;
          }

          // Otherwise allow system back to close the app
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.bg,
          body: IndexedStack(
            index: i,
            children: List.generate(pages.length, (idx) {
              return Offstage(
                offstage: i != idx,
                child: Navigator(
                  key: _ctrl.navKeys[idx],
                  onGenerateRoute: (settings) {
                    // this is each tab’s "root" page
                    return MaterialPageRoute(
                      builder: (_) => pages[idx],
                      settings: settings,
                    );
                  },
                ),
              );
            }),
          ),
          bottomNavigationBar: FFBottomNav(
            currentIndex: i,
            onTap: _ctrl.goTo,
          ),
        ),
      );
    });
  }
}
