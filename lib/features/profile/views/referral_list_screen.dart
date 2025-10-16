import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../controllers/referral_controller.dart';

class ReferralListScreen extends StatelessWidget {
  const ReferralListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReferralController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My referral')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.referrals.isEmpty) {
          return const Center(child: Text('No referrals yet'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.referrals.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final ref = controller.referrals[i];
            final color = _statusColor(ref.status);
            return ListTile(
              leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar_placeholder.png')),
              title: Text(ref.name),
              subtitle: Text(ref.email),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('\$${ref.amount.toStringAsFixed(0)}'),
                  Text(ref.status,
                      style: TextStyle(color: color, fontSize: 13)),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'joined':
        return AppColors.success;
      case 'cancelled':
        return AppColors.danger;
      case 'invited':
        return AppColors.warning;
      default:
        return AppColors.subtext;
    }
  }
}
