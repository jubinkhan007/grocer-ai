import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../../auth/auth_controller.dart';

Future<void> showLogoutDialog(BuildContext context) async {
  final auth = Get.find<AuthController>();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Obx(() {
            final busy = auth.isLoggingOut.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // teal circle with arrow icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded,
                      color: Colors.white, size: 34),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Are you sure you want to proceed?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: AppColors.subtext),
                ),
                const SizedBox(height: 22),

                Row(
                  children: [
                    // Ghost / outline "Cancel"
                    Expanded(
                      child: OutlinedButton(
                        onPressed: busy ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.teal, width: 1.4),
                          foregroundColor: AppColors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Solid teal "Logout"
                    Expanded(
                      child: ElevatedButton(
                        onPressed: busy ? null : () async {
                          await auth.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: busy
                            ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                            : const Text(
                          'Logout',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      );
    },
  );
}
