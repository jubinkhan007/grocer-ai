import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FFAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FFAppBar({super.key, required this.title, this.actions, this.leading});
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(title),
      actions: actions,
      backgroundColor: AppColors.teal,
    );
  }
}
