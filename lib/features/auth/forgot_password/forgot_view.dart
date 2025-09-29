// lib/features/auth/forgot/forgot_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/auth/forgot_password/utils/forgot_tokens.dart';
import 'package:grocer_ai/features/auth/forgot_password/widgets/forgot_widgets.dart';
import '../../../app/app_routes.dart';
import 'forgot_controller.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({super.key});

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
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: kTopTeal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Forgot Password',
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
                        'Enter your email for verifying',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF6B737C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PillField(
                      controller: controller.emailCtrl,
                      hint: 'Enter your email',
                      prefix: Image.asset(
                        'assets/icons/ic_mail.png',
                        width: 22,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 26),
                    Obx(
                      () => PrimaryBtn(
                        label: 'Send',
                        onPressed: controller.send,
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
