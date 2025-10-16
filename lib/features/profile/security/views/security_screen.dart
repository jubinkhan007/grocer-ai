import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../ui/theme/app_theme.dart';
import '../controllers/security_controller.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final oldController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  bool oldVisible = false;
  bool newVisible = false;
  bool confirmVisible = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SecurityController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Security'),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change password',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _passwordField(
                hint: 'Enter old password',
                controller: oldController,
                obscure: !oldVisible,
                onToggle: () => setState(() => oldVisible = !oldVisible),
              ),
              const SizedBox(height: 16),
              _passwordField(
                hint: 'Enter new password',
                controller: newController,
                obscure: !newVisible,
                onToggle: () => setState(() => newVisible = !newVisible),
              ),
              const SizedBox(height: 16),
              _passwordField(
                hint: 'Enter confirm password',
                controller: confirmController,
                obscure: !confirmVisible,
                onToggle: () => setState(() => confirmVisible = !confirmVisible),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                    await controller.updatePassword(
                      oldPass: oldController.text,
                      newPass: newController.text,
                      confirmPass: confirmController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Update password',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _passwordField({
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
        const Icon(Icons.lock_outline, color: AppColors.subtext, size: 22),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.subtext,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
