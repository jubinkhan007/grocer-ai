// lib/features/auth/forgot/forgot_widgets.dart
import 'package:flutter/material.dart';
import 'package:grocer_ai/features/auth/forgot_password/utils/forgot_tokens.dart';

class HeaderArc extends StatelessWidget {
  const HeaderArc({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(height: 156, color: kPageBg),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 220,
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
              child: Image.asset('assets/images/logo_grocerai.png', width: 210),
            ),
          ),
        ),
      ],
    );
  }
}

class PillField extends StatelessWidget {
  const PillField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefix,
    this.suffix,
    this.obscure = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final Widget prefix;
  final Widget? suffix;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
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
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          hintStyle: const TextStyle(
            color: kHint,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: const BorderSide(color: kTopTeal, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: kTopTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(44),
          ),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
