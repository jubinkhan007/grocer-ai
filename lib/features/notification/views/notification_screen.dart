import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shell/main_shell.dart';
import '../../../shell/main_shell_controller.dart';
import '../../../ui/theme/app_theme.dart';
import '../../shared/teal_app_bar.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: TealTitleAppBar(
        title: 'Notification',
        showBack: true,
        onBack: () async {
          // Try to pop THIS page using the local context
          final didPop = await Navigator.of(context).maybePop();
          if (didPop) return;

          // If we're inside MainShell, try popping the current tab's stack
          if (Get.isRegistered<MainShellController>()) {
            final shell = Get.find<MainShellController>();
            final i = shell.current.value;
            final nav = shell.navKeys[i].currentState;
            if (nav?.canPop() ?? false) {
              nav!.pop();
              return;
            }
            // Nothing to pop anywhere — optional final fallback: rebuild shell on same tab
            Get.offAll(() => MainShell(initialIndex: i));
            return;
          }

          // Not in shell and nothing to pop — hard fallback to shell home
          Get.offAll(() => MainShell(initialIndex: 0));
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications found'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final n = controller.notifications[index];
            return GestureDetector(
              onTap: () => _showGiftDialog(context, n),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 3)
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _brandLogo(n.source),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            n.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.text.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _timeAgo(n.createdAt),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _brandLogo(String source) {
    final logos = {
      'Fred Meyer': 'assets/images/fred_meyer.png',
      'Walmart': 'assets/images/walmart.png',
      'ALDI': 'assets/images/aldi.png',
      'United': 'assets/images/united.png',
    };
    final logoPath = logos[source] ?? 'assets/images/default.png';
    return Image.asset(logoPath, width: 38, height: 38);
  }

  String _timeAgo(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 365) return '${diff.inDays ~/ 365} yr ago';
      if (diff.inDays > 30) return '${diff.inDays ~/ 30} mo ago';
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      return '${diff.inMinutes}m ago';
    } catch (_) {
      return '';
    }
  }

  void _showGiftDialog(BuildContext context, AppNotification n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard,
                color: AppColors.teal, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Get a free gift',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'Today is a magic day. Special for you we offer unique gift. Free! We know you will like it!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  minimumSize: const Size(180, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text('Get now'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close',
                  style: TextStyle(color: AppColors.text)),
            )
          ],
        ),
      ),
    );
  }
}
