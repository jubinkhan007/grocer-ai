import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class PersonalInfoSheet extends StatelessWidget {
  const PersonalInfoSheet({super.key});

  // design tokens pulled from Figma
  static const _sheetBg = Color(0xFFF4F6F6); // same bg as Settings screen
  static const _textPrimary = Color(0xFF212121); // almost black
  static const _teal = Color(0xFF33595B); // Grocer teal
  static const _divider = Color(0xFFE0E0E0); // 1px hairline under header
  static const _grabberGrey = Color(0xFFCBC4C4); // tiny pill color

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final info = controller.personalInfo.value;
      final isLoading = controller.isLoading.value;

      return SafeArea(
        // only respect bottom inset; we want to hug the bottom like the mock
        top: false,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: _sheetBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            // Figma shows ~16 padding above header after grabber,
            // and ~24 bottom safe space.
            top: 8,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
          ),
          child: isLoading
              ? const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== grabber with halo =====
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _grabberGrey,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      // soft glow under grabber like in your screenshot
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== header row =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Personal information',
                      style: TextStyle(
                        color: _textPrimary,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        height: 1.3,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // TODO: open edit sheet / inline form
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2, left: 8),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: _teal,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // thin divider under header
              Container(
                width: double.infinity,
                height: 1,
                color: _divider,
              ),

              const SizedBox(height: 24),

              // ===== info rows (icon teal, text dark) =====
              _InfoRow(
                icon: Icons.person_outline,
                text: info?.name ?? '-',
              ),
              const SizedBox(height: 24),

              _InfoRow(
                icon: Icons.email_outlined,
                text: info?.email ?? '-',
              ),
              const SizedBox(height: 24),

              _InfoRow(
                icon: Icons.phone_outlined,
                text: info?.mobileNumber ?? '-',
              ),

              // no trailing buttons, no list scroll: content fits.
            ],
          ),
        ),
      );
    });
  }
}

/// one line in the list like:
/// [ teal icon ] 12px gap [ dark text ]
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  static const _teal = Color(0xFF33595B);
  static const _textPrimary = Color(0xFF212121);

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 28, // screenshot icons look ~28 not 20
          color: _teal,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _textPrimary,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 18,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
