import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

const _topTeal = Color(0xFF0C3E3D);
const _pageBg = Color(0xFFF1F4F6);

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
        //top: false,
        child: Column(
          children: [
            // Top teal strip w/ curved white arc & centered logo
            const _LoginHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _FieldWithBubble(
                      errorTextRx: controller.emailError,
                      child: _RoundedField(
                        controller: controller.emailCtrl,
                        hint: 'Enter your email',
                        prefix: Image.asset(
                          'assets/icons/ic_mail.png',
                          width: 22,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    _FieldWithBubble(
                      errorTextRx: controller.passError,
                      child: Obx(
                        () => _RoundedField(
                          controller: controller.passCtrl,
                          hint: 'Enter your password',
                          prefix: Image.asset(
                            'assets/icons/ic_lock.png',
                            width: 22,
                          ),
                          obscureText: controller.obscure.value,
                          suffix: IconButton(
                            onPressed: controller.toggleObscure,
                            icon: Icon(
                              controller.obscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.forgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: _topTeal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: _topTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          onPressed: controller.loading.value
                              ? null
                              : controller.signIn,
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
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    const _OrContinue(),

                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialBtn(
                          asset: 'assets/icons/ic_google.png',
                          onTap: controller.google,
                        ),
                        const SizedBox(width: 16),
                        _SocialBtn(
                          asset: 'assets/icons/ic_facebook.png',
                          onTap: controller.facebook,
                        ),
                        const SizedBox(width: 16),
                        _SocialBtn(
                          asset: 'assets/icons/ic_apple.png',
                          onTap: controller.apple,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an Account?"),
                        TextButton(
                          onPressed: () =>
                              Get.snackbar('Sign Up', 'Navigate to Sign Up'),
                          child: const Text(
                            'Sign Up',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Container(height: 44, width: double.infinity, color: _topTeal),
        // Curved white arc over grey background + centered logo
        Stack(
          children: [
            Container(height: 120, color: _pageBg),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(500),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Image.asset(
                    'assets/images/logo_grocerai.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// rounded, filled text field (matches pill look)
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
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: prefix,
              ),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: _topTeal, width: 1.4),
        ),
      ),
    );
  }
}

/// Shows a small “bubble” error badge at the right, like your Figma
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
              top: -8,
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
                    BoxShadow(color: Colors.black12, blurRadius: 4),
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
          child: Divider(endIndent: 12, thickness: 1, color: Color(0xFFE1E6EA)),
        ),
        Text('Or Continue with', style: Theme.of(context).textTheme.bodyLarge),
        const Expanded(
          child: Divider(indent: 12, thickness: 1, color: Color(0xFFE1E6EA)),
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
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(asset, width: 24, height: 24, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
