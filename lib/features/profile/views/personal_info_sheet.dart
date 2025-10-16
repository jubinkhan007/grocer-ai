import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class PersonalInfoSheet extends StatelessWidget {
  const PersonalInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Obx(() {
          final info = controller.personalInfo.value;
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Personal information',
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      // TODO: open edit sheet or inline form
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _infoRow(Icons.person_outline, info?.name ?? '-'),
              const SizedBox(height: 16),
              _infoRow(Icons.email_outlined, info?.email ?? '-'),
              const SizedBox(height: 16),
              _infoRow(Icons.phone_outlined, info?.mobileNumber ?? '-'),
            ],
          );
        });
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.teal),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
