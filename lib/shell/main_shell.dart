// lib/shell/main_shell.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/help/views/help_support_screen.dart';
import 'package:grocer_ai/features/orders/views/orders_screen.dart';
import 'package:grocer_ai/features/profile/settings/settings_screen.dart';
import '../features/offer/views/offer_screen.dart';
import '../ui/theme/app_theme.dart';
import '../widgets/ff_bottom_nav.dart';
import 'main_shell_controller.dart';

// tab roots
import '../features/home/dashboard_screen.dart';

class MainShell extends StatelessWidget {
  MainShell({super.key, int? initialIndex}) {
    // If you navigate here with an initial index, set it.
    if (initialIndex != null) {
      Get.put(MainShellController()).goTo(initialIndex);
    }
  }

  final _ctrl = Get.find<MainShellController>();

  // optional: separate navigators per tab (so each tab keeps its own back stack)
  final _keys = List.generate(5, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DashboardScreen(),
      const OfferScreen(),
      const OrderScreen(),
      const HelpSupportScreen(),
      const SettingsScreen(),
    ];

    return Obx(() {
      final i = _ctrl.current.value;

      return WillPopScope(
        onWillPop: () async {
          // handle back per-tab: pop tab stack first
          final canPop = _keys[i].currentState?.canPop() ?? false;
          if (canPop) {
            _keys[i].currentState?.pop();
            return false;
          }
          // if on non-home tab, go home instead of leaving app
          if (i != 0) {
            _ctrl.goTo(0);
            return false;
          }
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
                  key: _keys[idx],
                  onGenerateRoute: (settings) {
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
