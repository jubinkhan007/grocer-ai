// lib/features/auth/login/login_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'login_controller.dart';

/// ===== Figma base frame =====
const _baseW = 430.0;
const _baseH = 932.0;

/// Colors from plugin
const _bg      = Color(0xFFF4F6F6);
const _status  = Color(0xFF002C2E);
const _chipBg  = Color(0xFFFEFEFE);
const _title   = Color(0xFF212121);
const _hint    = Color(0xFF999999);
const _cta     = Color(0xFF33595B);
const _link    = Color(0xFF33595B);
const _divider = Color(0xFFE9E9E9);

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark text/icons on light header
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    final size = MediaQuery.of(context).size;
    final sx = size.width / _baseW;
    final sy = size.height / _baseH;

    double s(double v) => v * sx; // scale by width for consistent look
    double syy(double v) => v * sy;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          /// === Big oval background (700×700 at −135, −350) ===
          Positioned(
            left: s(-135),
            top: syy(-350),
            child: Container(
              width: s(700),
              height: s(700),
              decoration: const ShapeDecoration(
                color: Color(0xFFE6EAEB),
                shape: OvalBorder(),
              ),
            ),
          ),

          /// === Status strip (430×48.14, #002C2E) ===
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: size.width,
              height: syy(48.14),
              color: _status,
              // (we don't render fake iOS glyphs; OS will draw real ones)
            ),
          ),

          /// === Center logo block (200×100 at left:115, top:174) ===
          Positioned(
            left: s(115),
            top: syy(174),
            child: SizedBox(
              width: s(200),
              height: syy(100),
              child: Image.asset(
                'assets/images/logo_grocerai.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// === Form column (frame at left:24, top:427, width:382) ===
          Positioned(
            left: s(24),
            top: syy(427),
            width: s(382),
            child: _LoginFormExact(
              s: s,
              sy: syy,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFormExact extends GetView<LoginController> {
  const _LoginFormExact({required this.s, required this.sy});
  final double Function(double) s;
  final double Function(double) sy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// "Welcome Back"
        Text(
          'Welcome Back',
          style: TextStyle(
            color: _title,
            fontSize: s(24),
            fontWeight: FontWeight.w700,
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: sy(24)),

        /// Email field capsule (height from plugin via padding)
        _CapsuleField(
          s: s,
          sy: sy,
          hint: 'Enter your email',
          controller: controller.emailCtrl,
          prefix: Icons.mail_outline,
          obscure: false,
        ),
        SizedBox(height: sy(20)),

        /// Password field capsule (with eye)
        Obx(() => _CapsuleField(
          s: s,
          sy: sy,
          hint: 'Enter your password',
          controller: controller.passCtrl,
          prefix: Icons.lock_outline,
          suffix: GestureDetector(
            onTap: controller.toggleObscure,
            child: Icon(
              controller.obscure.value ? Icons.visibility : Icons.visibility_off,
              size: s(20),
              color: const Color(0xFF7B8B95),
            ),
          ),
          obscure: controller.obscure.value,
        )),

        SizedBox(height: sy(20)),

        /// Forgot password (382 width, right aligned)
        SizedBox(
          width: s(382),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.forgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: _link,
                  fontSize: s(14),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: sy(24)),

        /// Sign In button (height 56, radius 100)
        SizedBox(
          width: double.infinity,
          height: sy(56),
          child: Obx(() => TextButton(
            onPressed:
            controller.loading.value ? null : controller.signIn,
            style: TextButton.styleFrom(
              backgroundColor: _cta,
              foregroundColor: const Color(0xFFFEFEFE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(s(100)),
              ),
            ),
            child: controller.loading.value
                ? const SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
              'Sign In',
              style: TextStyle(
                fontSize: s(16),
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
          )),
        ),

        SizedBox(height: sy(16)),

        /// "Or Continue with"
        Opacity(
          opacity: 0.60,
          child: SizedBox(
            width: s(382),
            child: Text(
              'Or Continue with',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _title,
                fontSize: s(14),
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),

        SizedBox(height: sy(8)),

        /// Social row — three circular 43.38 buttons with 1.46 border
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Social(s: s, iconAsset: 'assets/icons/ic_google.png', onTap: controller.google),
            SizedBox(width: s(24)),
            _Social(s: s, iconAsset: 'assets/icons/ic_facebook.png', onTap: controller.facebook),
            SizedBox(width: s(24)),
            _Social(s: s, iconAsset: 'assets/icons/ic_apple.png', onTap: controller.apple),
          ],
        ),

        SizedBox(height: sy(4)),

        /// Bottom sign-up row
        Padding(
          padding: EdgeInsets.symmetric(vertical: sy(7)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don’t have an Account?',
                style: TextStyle(
                  color: const Color(0xFF4D4D4D),
                  fontSize: s(16),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(width: s(8)),
              TextButton(
                onPressed: () => Get.toNamed(Routes.signup),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: _link,
                    fontSize: s(16),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CapsuleField extends StatelessWidget {
  const _CapsuleField({
    required this.s,
    required this.sy,
    required this.hint,
    required this.controller,
    this.prefix,
    this.suffix,
    this.obscure = false,
  });

  final double Function(double) s;
  final double Function(double) sy;
  final String hint;
  final TextEditingController controller;
  final IconData? prefix;
  final Widget? suffix;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(s(128));
    return Container(
      padding: EdgeInsets.all(s(16)),
      decoration: ShapeDecoration(
        color: _chipBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(s(128)),
        ),
      ),
      child: Row(
        children: [
          if (prefix != null)
            Padding(
              padding: EdgeInsets.only(right: s(8)),
              child: Icon(prefix, size: s(20), color: _hint),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: hint,
                hintStyle: TextStyle(
                  color: _hint,
                  fontSize: s(14),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                ),
                // make every state borderless
                filled: true,
                fillColor: _chipBg,
                border: OutlineInputBorder(borderRadius: r, borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: r, borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: r, borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(borderRadius: r, borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(borderRadius: r, borderSide: BorderSide.none),
                focusedErrorBorder: OutlineInputBorder(borderRadius: r, borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(color: _title, fontSize: s(14), fontFamily: 'Roboto'),
            )
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}

class _Social extends StatelessWidget {
  const _Social({required this.s, required this.iconAsset, required this.onTap});
  final double Function(double) s;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(s(8)),
      child: Padding(
        // subtle padding for a ~44px hit area without showing a circle
        padding: EdgeInsets.all(s(8)),
        child: Image.asset(
          iconAsset,
          width: s(43),
          height: s(43),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
