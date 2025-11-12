// lib/features/shared/widgets/teal_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/checkout/utils/design_tokens.dart';

const Color appBarTextColor = Color(0xFFFEFEFE);

/// Base shell: dark status strip + teal header.
/// Used by all variants so visuals stay identical.
class TealAppBarShell extends StatelessWidget {
  final Widget child;

  const TealAppBarShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: statusTeal,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    // Figma: status bar strip + 68px teal toolbar
    return SizedBox(
      height: paddingTop + 68,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // dark status strip
          Container(
            height: paddingTop,
            width: double.infinity,
            color: statusTeal,
          ),
          // teal toolbar (fixed 68px)
          Container(
            height: 68,
            width: double.infinity,
            color: headerTeal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Back chevron + title (or just title) + optional trailing.
class TealTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  const TealTitleAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.trailing,
  });

  // status strip + 68 toolbar; give Scaffold a safe upper bound
  @override
  Size get preferredSize => const Size.fromHeight(116);

  @override
  Widget build(BuildContext context) {
    return TealAppBarShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBack)
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: onBack ?? Get.back,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: appBarTextColor,
              ),
            ),
          if (showBack) const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: appBarTextColor,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Home variant: Hi, Name + location + bell.
class TealHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String location;
  final VoidCallback? onBellTap;
  final bool showDot;

  const TealHomeAppBar({
    super.key,
    required this.name,
    required this.location,
    this.onBellTap,
    this.showDot = false,
  });

  // Slightly taller content but still within the same shell height.
  @override
  Size get preferredSize => const Size.fromHeight(116);

  @override
  Widget build(BuildContext context) {
    return TealAppBarShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Hi, ',
                        style: TextStyle(
                          color: appBarTextColor,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: name,
                        style: const TextStyle(
                          color: appBarTextColor,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Color(0xFFB0C7C8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Color(0xFFB0C7C8),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onBellTap,
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 28,
                  color: appBarTextColor,
                ),
                if (showDot)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5A36),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
