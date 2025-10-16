import 'package:flutter/material.dart';
import '../../../ui/widgets/ff_app_bar.dart';
import '../../../ui/widgets/section_card.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FFAppBar(title: 'Invite friends'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Share your invite link'),
              const SizedBox(height: 8),
              SelectableText('https://grocer.ai/invite/NAFIZ-1K'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Use share_plus in your project to open native share
                    // Share.share('Join me on GrocerAI: https://grocer.ai/invite/NAFIZ-1K');
                  },
                  child: const Text('Share'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
