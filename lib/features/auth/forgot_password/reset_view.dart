// lib/features/auth/forgot/reset_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/auth/forgot_password/utils/forgot_tokens.dart';
import 'package:grocer_ai/features/auth/forgot_password/widgets/forgot_widgets.dart';
import 'reset_controller.dart';

class ResetView extends GetView<ResetController> {
  const ResetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderArc(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: Get.back,
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: kTopTeal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Set New Password',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF33363E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 48),
                      child: Text(
                        'Create a new password',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF6B737C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => PillField(
                        controller: controller.passCtrl,
                        hint: 'Enter new password',
                        obscure: controller.obscure.value,
                        prefix: Image.asset(
                          'assets/icons/ic_lock.png',
                          width: 22,
                        ),
                        suffix: IconButton(
                          splashRadius: 22,
                          onPressed: controller.toggle,
                          icon: Icon(
                            controller.obscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF7B8B95),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Obx(
                      () => PrimaryBtn(
                        label: 'Send',
                        onPressed: controller.submit,
                        loading: controller.loading.value,
                      ),
                    ),
                    Obx(
                      () => controller.error.value == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                controller.error.value!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
