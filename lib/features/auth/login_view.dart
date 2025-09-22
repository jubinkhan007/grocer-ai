import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

/// Colors that match the Figma
const _topTeal = Color(0xFF0C3E3D);
const _pageBg = Color(0xFFF1F4F6);
const _hint = Color(0xFF9AA4AE);
const _divider = Color(0xFFE1E6EA);

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark icons on the light header arc, like the frame
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
            _HeaderArc(), // exact Figma-style arc + logo
            Expanded(child: _FormArea()),
          ],
        ),
      ),
    );
  }
}

class _HeaderArc extends StatelessWidget {
  const _HeaderArc();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // page background under the arc
        Container(height: 156, color: _pageBg),

        // the shallow white arc (uses elliptical radius to match Figma)
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

        // centered logo sitting on the arc
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Image.asset(
                'assets/images/logo_grocerai.png',
                width: 210, // slightly larger to match the composition
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormArea extends GetView<LoginController> {
  const _FormArea();

  @override
  Widget build(BuildContext context) {
    final h1 = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF33363E),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome Back', style: h1),
          const SizedBox(height: 24),

          // Email
          _FieldWithBubble(
            errorTextRx: controller.emailError,
            child: _RoundedField(
              controller: controller.emailCtrl,
              hint: 'zararahman@gmail.com', // matches mock placeholder style
              prefix: Image.asset('assets/icons/ic_mail.png', width: 22),
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
                hint: '••••••••••',
                prefix: Image.asset('assets/icons/ic_lock.png', width: 22),
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

          const SizedBox(height: 10),
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
              height: 64, // bigger capsule like Figma
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _topTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(44),
                  ),
                ),
                onPressed: controller.loading.value ? null : controller.signIn,
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
                        'Sign In',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Divider(endIndent: 12, thickness: 1, color: _divider),
              ),
              Text(
                'Or Continue with',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B737C)),
              ),
              const Expanded(
                child: Divider(indent: 12, thickness: 1, color: _divider),
              ),
            ],
          ),

          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialBtn(
                asset: 'assets/icons/ic_google.png',
                onTap: controller.google,
              ),
              const SizedBox(width: 20),
              _SocialBtn(
                asset: 'assets/icons/ic_facebook.png',
                onTap: controller.facebook,
              ),
              const SizedBox(width: 20),
              _SocialBtn(
                asset: 'assets/icons/ic_apple.png',
                onTap: controller.apple,
              ),
            ],
          ),

          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Don’t have an Account?"), _SignUpLink()],
          ),
        ],
      ),
    );
  }
}

/// rounded, filled text field with subtle elevation to match the pill look
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
        ), // ~64 tall
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: const BorderSide(color: _topTeal, width: 1.4),
        ),
      ),
    );

    // Soft shadow like the mock (very subtle)
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

/// Error bubble that pins to the field’s right edge (copy text from controller)
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

class _OrContinue extends StatelessWidget {
  const _OrContinue();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(endIndent: 12, thickness: 1, color: _divider),
        ),
        Text(
          'Or Continue with',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF6B737C)),
        ),
        const Expanded(
          child: Divider(indent: 12, thickness: 1, color: _divider),
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  const _SocialBtn({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Ink(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFEAEFF2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(asset, width: 26, height: 26, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.snackbar('Sign Up', 'Navigate to Sign Up'),
      child: const Text(
        '  Sign Up', // leading spaces for the exact kerning in the frame
        style: TextStyle(color: _topTeal, fontWeight: FontWeight.w700),
      ),
    );
  }
}
