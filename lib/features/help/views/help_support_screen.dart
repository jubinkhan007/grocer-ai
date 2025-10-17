import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../widgets/ff_bottom_nav.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // Set to your Help tab index in FFBottomNav (Home=0, Offer=1, Order=2, Help=3, Profile=4)
  int _tab = 3;

  // 🔌 API / Live-chat stub – replace when backend is ready
  Future<void> _openLiveChat() async {
    // TODO: open your live chat page/screen
    Get.snackbar('Live chat', 'Hook me up to your live chat when ready.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // top app bar matching figma
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.teal,
            elevation: 0,
            collapsedHeight: 72,
            titleSpacing: 0,
            title: Container(
              color: AppColors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: const [
                    BackButton(color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Help & Support',
                      style: TextStyle(
                        color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We're here to assist you! Find quick answers to your "
                        "questions or contact us directly for help.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.text, height: 1.35),
                  ),
                  const SizedBox(height: 16),

                  // Contact Us
                  _SectionCard(
                    title: 'Contact Us',
                    children: const [
                      _RowRich(
                        leading: 'Live Chat',
                        value:
                        'Available 24/7 directly in the app.',
                      ),
                      _DividerLine(),
                      _RowRich(
                        leading: 'Phone Support',
                        value:
                        'Call us at 1-800-123-4567, Mon–Fri, 8 AM–8 PM EST.',
                      ),
                      _DividerLine(),
                      _RowRich(
                        leading: 'Email Support',
                        value: 'Reach us at support@[appname].com.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Delivery & Returns
                  _SectionCard(
                    title: 'Delivery & Returns',
                    children: const [
                      _RowRich(
                        leading: 'Delivery Area',
                        value:
                        'Available in most areas within [State(s)].',
                      ),
                      _DividerLine(),
                      _RowRich(
                        leading: 'Returns',
                        value:
                        'Return items within 7 days for a full refund.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Account & Privacy
                  _SectionCard(
                    title: 'Account & Privacy',
                    children: const [
                      _RowRich(
                        leading: 'Update Info',
                        value:
                        'Change your details in the profile settings.',
                      ),
                      _DividerLine(),
                      _RowRich(
                        leading: 'Password Reset',
                        value:
                        'Tap “Forgot Password?” on the login page to reset.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // big floating assistant button (bottom-right), matches mock
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
        child: SizedBox(
          height: 68,
          width: 68,
          child: FloatingActionButton(
            onPressed: _openLiveChat,
            backgroundColor: AppColors.teal,
            elevation: 2,
            shape: const CircleBorder(),
            child: _BotIcon(),
          ),
        ),
      ),

      // your shared bottom nav
      bottomNavigationBar: FFBottomNav(
        currentIndex: _tab,
        onTap: (i) {
          setState(() => _tab = i);
          // TODO: switch tabs with your existing router if needed
        },
      ),
    );
  }
}

/// ---------- Pieces ----------
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1),
    );
  }
}

class _RowRich extends StatelessWidget {
  const _RowRich({required this.leading, required this.value});
  final String leading;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: AppColors.text, height: 1.5),
        children: [
          TextSpan(
              text: '$leading: ',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _BotIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // If you add your bot asset later (e.g. assets/icons/bot.png), replace with Image.asset
    return const Icon(Icons.support_agent, color: Colors.white, size: 30);
  }
}
