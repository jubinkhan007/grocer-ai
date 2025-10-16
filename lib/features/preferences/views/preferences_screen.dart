import 'package:flutter/material.dart';

import '../../../ui/widgets/ff_app_bar.dart';
import '../../../ui/widgets/section_card.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool notifPush = true;
  bool notifEmail = false;
  bool notifSMS = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FFAppBar(title: 'Preferences'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  value: notifPush,
                  onChanged: (v) => setState(() => notifPush = v),
                  title: const Text('Push notifications'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: notifEmail,
                  onChanged: (v) => setState(() => notifEmail = v),
                  title: const Text('Email'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: notifSMS,
                  onChanged: (v) => setState(() => notifSMS = v),
                  title: const Text('SMS'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: ListTile(
              title: const Text('Language'),
              subtitle: const Text('English (US)'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
