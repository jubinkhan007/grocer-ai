import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../models/personal_info_model.dart';

class PersonalInfoSheet extends StatelessWidget {
  const PersonalInfoSheet({super.key});

  // design tokens
  static const _sheetBg = Color(0xFFF4F6F6);
  static const _textPrimary = Color(0xFF212121);
  static const _teal = Color(0xFF33595B);
  static const _divider = Color(0xFFE0E0E0);
  static const _grabberGrey = Color(0xFFCBC4C4);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final info = controller.personalInfo.value;
      final isLoading = controller.isLoading.value;

      return SafeArea(
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
              // grabber
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _grabberGrey,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
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

              // header + Edit
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
                      // open edit sheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.black.withOpacity(0.4),
                        builder: (_) => _EditPersonalInfoSheet(
                          name: info?.name ?? '',
                          email: info?.email ?? '',
                          phone: info?.mobileNumber ?? '',
                        ),
                      );
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

              // divider
              Container(height: 1, color: _divider),
              const SizedBox(height: 24),

              // info rows
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
            ],
          ),
        ),
      );
    });
  }
}

/// display row in the view sheet
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
        Icon(icon, size: 28, color: _teal),
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

/// ================= EDIT SHEET (Figma: Edit account) =================

class _EditPersonalInfoSheet extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const _EditPersonalInfoSheet({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<_EditPersonalInfoSheet> createState() =>
      _EditPersonalInfoSheetState();
}

class _EditPersonalInfoSheetState extends State<_EditPersonalInfoSheet> {
  static const _sheetBg = Color(0xFFF4F6F6);
  static const _textPrimary = Color(0xFF212121);
  static const _teal = Color(0xFF33595B);
  static const _divider = Color(0xFFE0E0E0);
  static const _grabberGrey = Color(0xFFCBC4C4);

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _emailCtrl = TextEditingController(text: widget.email);
    _phoneCtrl = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final controller = Get.find<ProfileController>();
    final current = controller.personalInfo.value;

    final updated = PersonalInfo(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobileNumber: _phoneCtrl.text.trim(),
      workAt: current?.workAt,
    );

    try {
      await controller.updatePersonalInfo(updated, partial: true);
      Get.back(); // close edit sheet on success
    } catch (e) {
      // show server-side validation (e.g. invalid phone) instead of crashing
      Get.snackbar(
        'Update failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          top: 8,
          bottom: 24 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // grabber
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: _grabberGrey,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: const [
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

            // top bar: Edit account + Save (matches Figma)
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Edit account',
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
                  onTap: _save,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 16, top: 2),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: _teal,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Container(height: 1, color: _divider),
            const SizedBox(height: 24),

            // Name
            _LabeledField(
              label: 'Name',
              controller: _nameCtrl,
              keyboardType: TextInputType.name,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 24),

            // Email
            _LabeledField(
              label: 'Email',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 24),

            // Phone with trailing flag (static, purely visual)
            _LabeledField(
              label: 'Phone',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              icon: Icons.phone_outlined,
              trailing: const _PhoneFlagTrailing(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Label + pill field with leading icon (and optional trailing widget)
class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData icon;
  final Widget? trailing;

  static const _textPrimary = Color(0xFF212121);
  static const _teal = Color(0xFF33595B);

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        Text(
          label,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),

        // pill field
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 22, color: _teal),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ],
    );
  }
}

/// Right-side separator + circular flag bubble for phone field.
class _PhoneFlagTrailing extends StatelessWidget {
  const _PhoneFlagTrailing();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // vertical divider
        Container(
          width: 1,
          height: 32,
          color: const Color(0xFFE0E0E0),
        ),
        const SizedBox(width: 12),
        // flag bubble (use your actual asset here if available)
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // Placeholder: swap with AssetImage for real flag.
            color: Color(0xFFE0E0E0),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.flag,
            size: 16,
            color: Color(0xFF33595B),
          ),
        ),
      ],
    );
  }
}
