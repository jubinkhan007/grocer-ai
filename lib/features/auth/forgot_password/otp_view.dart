// lib/features/auth/forgot/otp_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/auth/forgot_password/utils/forgot_tokens.dart';
import 'package:grocer_ai/features/auth/forgot_password/widgets/forgot_widgets.dart';
import 'otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

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
                          'Verify Email',
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
                        'Enter the OTP sent to your email',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF6B737C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _OtpBoxes(onChanged: (v) => controller.code.value = v),

                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Didn't receive OTP?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF6B737C),
                            ),
                          ),
                          Obx(() {
                            final disabled =
                                controller.secondsLeft.value > 0 ||
                                controller.resendLoading.value;
                            return TextButton(
                              onPressed: disabled ? null : controller.resend,
                              child: controller.resendLoading.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      disabled
                                          ? 'Resend code in ${controller.timerText}'
                                          : 'Resend code',
                                      style: TextStyle(
                                        color: disabled
                                            ? Colors.grey
                                            : kTopTeal,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Obx(
                      () => PrimaryBtn(
                        label: 'Submit',
                        onPressed: controller.verify,
                        loading: controller.loading.value,
                      ),
                    ),

                    const SizedBox(height: 18),
                    // Live MM:SS timer under the button (optional; keep to match Figma)
                    Obx(
                      () => Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Dynamic password will expire in:  ',
                                style: TextStyle(color: Color(0xFF6B737C)),
                              ),
                              TextSpan(
                                text: controller.timerText,
                                style: const TextStyle(
                                  color: kTopTeal,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
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

class _OtpBoxes extends StatefulWidget {
  const _OtpBoxes({required this.onChanged});
  final ValueChanged<String> onChanged;
  @override
  State<_OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<_OtpBoxes> {
  final _nodes = List.generate(6, (_) => FocusNode());
  final _ctls = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (final n in _nodes) n.dispose();
    for (final c in _ctls) c.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged(_ctls.map((c) => c.text).join());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == 5 ? 0 : 12),
            height: 64,
            child: TextField(
              controller: _ctls[i],
              focusNode: _nodes[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kTopTeal),
                ),
              ),
              onChanged: (v) {
                if (v.isNotEmpty && i < 5) _nodes[i + 1].requestFocus();
                if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                _emit();
              },
            ),
          ),
        );
      }),
    );
  }
}
