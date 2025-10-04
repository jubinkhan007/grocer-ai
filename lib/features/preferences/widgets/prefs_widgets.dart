// lib/features/preferences/widgets/prefs_widgets.dart
import 'package:flutter/material.dart';

const _topTeal = Color(0xFF0C3E3D);
const _pageBg = Color(0xFFF1F4F6);

class HeaderArc extends StatelessWidget {
  const HeaderArc({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(height: 104, color: _pageBg),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(w, 120),
                bottomRight: Radius.elliptical(w, 120),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PrimaryBarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool loading;
  final Widget? child;
  const PrimaryBarButton({
    super.key,
    this.onTap,
    this.loading = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _topTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(44),
            ),
          ),
          onPressed: loading ? null : onTap,
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : (child ??
                    const Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                      size: 28,
                    )),
        ),
      ),
    );
  }
}

const kTopTeal = Color(0xFF0C3E3D);

class NoteField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const NoteField({super.key, required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, right: 12),
          child: Icon(Icons.shopping_basket_outlined, color: Color(0xFF2F6767)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: const BorderSide(color: kTopTeal, width: 1.2),
        ),
      ),
    );
  }
}
