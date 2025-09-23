import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';

const _topTeal = Color(0xFF0C3E3D);
const _pageBg = Color(0xFFF1F4F6);
const _hint = Color(0xFF9AA4AE);
const _divider = Color(0xFFE1E6EA);

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Column(
          children: const [
            _HeaderArc(), // same shallow arc + centered logo
            Expanded(child: _FormArea()),
          ],
        ),
      ),
    );
  }
}

/// Arc header that matches the mock exactly (elliptical radius)
class _HeaderArc extends StatelessWidget {
  const _HeaderArc();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(height: 156, color: _pageBg),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(w, 170),
                bottomRight: Radius.elliptical(w, 170),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Image.asset(
                'assets/images/logo_grocerai.png',
                width: 210,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormArea extends GetView<SignUpController> {
  const _FormArea();

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF33363E),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create Account', style: title),
          const SizedBox(height: 24),

          // Name
          _FieldWithBubble(
            errorTextRx: controller.nameError,
            child: _RoundedField(
              controller: controller.nameCtrl,
              hint: 'Enter your name',
              prefix: _iconAsset(
                'assets/icons/ic_user.png',
                Icons.person_outline,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Email
          _FieldWithBubble(
            errorTextRx: controller.emailError,
            child: _RoundedField(
              controller: controller.emailCtrl,
              hint: 'Enter your email',
              prefix: _iconAsset(
                'assets/icons/ic_mail.png',
                Icons.mail_outline,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 16),

          // Password
          _FieldWithBubble(
            errorTextRx: controller.passError,
            child: Obx(
              () => _RoundedField(
                controller: controller.passCtrl,
                hint: 'Enter your password',
                prefix: _iconAsset(
                  'assets/icons/ic_lock.png',
                  Icons.lock_outline,
                ),
                obscureText: controller.obscure.value,
                suffix: IconButton(
                  splashRadius: 22,
                  onPressed: controller.toggleObscure,
                  icon: Icon(
                    controller.obscure.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF7B8B95),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Referral (optional)
          _FieldWithBubble(
            errorTextRx: controller.referralErr,
            child: _RoundedField(
              controller: controller.referralCtrl,
              hint: 'Enter your referral code',
              prefix: _iconAsset(
                'assets/icons/ic_referral.png',
                Icons.person_2_outlined,
              ),
            ),
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.forgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
              ),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: _topTeal, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 64,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _topTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(44),
                  ),
                ),
                onPressed: controller.loading.value ? null : controller.signUp,
                child: controller.loading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an Account?"),
              TextButton(
                onPressed: () =>
                    Get.back(), // or navigate by name to your login route
                child: const Text(
                  '  Sign In',
                  style: TextStyle(
                    color: _topTeal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// pill input with subtle drop shadow (matches Figma)
class _RoundedField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _RoundedField({
    required this.controller,
    required this.hint,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, color: Color(0xFF33363E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: _hint,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: prefix,
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(36)),
          borderSide: BorderSide(color: _topTeal, width: 1.4),
        ),
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: field,
    );
  }
}

/// little orange bubble error (same style as your login)
class _FieldWithBubble extends StatelessWidget {
  final Widget child;
  final RxnString errorTextRx;
  const _FieldWithBubble({required this.child, required this.errorTextRx});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final text = errorTextRx.value;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (text != null)
            Positioned(
              right: 10,
              top: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE86F47)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFFE86F47),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Color(0xFFE86F47),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

/// Tries to use an asset; falls back to a Material icon if the asset isn’t found
Widget _iconAsset(String assetPath, IconData fallback) {
  return Image.asset(
    assetPath,
    width: 22,
    errorBuilder: (_, __, ___) => Icon(fallback, size: 22, color: _topTeal),
  );
}
