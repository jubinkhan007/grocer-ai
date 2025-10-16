import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../controllers/partner_controller.dart';

class PartnerSheet extends StatelessWidget {
  const PartnerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartnerController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (_, scrollController) {
        return Obx(() {
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
                  Text('Partner', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      _showAddPartnerDialog(context, controller);
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              for (final p in controller.partners)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppSpacings.r),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, color: AppColors.teal),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.removePartner(p.id),
                        icon: const Icon(Icons.close, color: AppColors.danger),
                      )
                    ],
                  ),
                ),

              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showAddPartnerDialog(context, controller),
                child: Row(
                  children: const [
                    Icon(Icons.add, color: AppColors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Add new partner',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }

  void _showAddPartnerDialog(
      BuildContext context, PartnerController controller) {
    final TextEditingController nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Partner'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              await controller.addPartner(nameCtrl.text.trim());
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
