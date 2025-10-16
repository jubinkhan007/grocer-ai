import 'package:flutter/material.dart';
import '../../../ui/widgets/ff_app_bar.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/section_card.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final oldC = TextEditingController();
    final newC = TextEditingController();
    final repC = TextEditingController();

    return Scaffold(
      appBar: const FFAppBar(title: 'Security'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: SectionCard(
          child: Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  controller: oldC,
                  decoration: const InputDecoration(labelText: 'Current password'),
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacings.md),
                TextFormField(
                  controller: newC,
                  decoration: const InputDecoration(labelText: 'New password'),
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacings.md),
                TextFormField(
                  controller: repC,
                  decoration: const InputDecoration(labelText: 'Re-type new password'),
                  obscureText: true,
                ),
                const SizedBox(height: AppSpacings.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: integrate with /change-password endpoint
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password updated')),
                      );
                    },
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
