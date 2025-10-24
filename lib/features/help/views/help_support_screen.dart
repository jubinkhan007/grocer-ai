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
  // Help tab index in your bottom nav: Home=0, Offer=1, Order=2, Help=3, Profile=4
  int _tab = 3;

  Future<void> _openLiveChat() async {
    Get.snackbar('Live chat', 'Hook me up to your live chat when ready.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6), // Figma page bg
      body: CustomScrollView(
        slivers: [
          /// ===== Top app bar (Figma: header block under status 69px) =====
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF33595B),
            // 48 (status area) + 69 (header) ~= 117 visual height in Figma
            collapsedHeight: 117,
            expandedHeight: 117,
            titleSpacing: 0,
            title: Container(
              color: const Color(0xFF33595B),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: const [
                    // iOS-style arrow used in the comps
                    Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Help & Support',
                      // Figma: 20 / 700 / white
                      style: TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ===== Body =====
          SliverToBoxAdapter(
            child: Padding(
              // Figma page padding: 24 left/right, top space below header
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Intro copy (Figma: 14 / 400 / #212121 / lh 1.43)
                  Text(
                    'We’re here to assist you! Find quick answers to your questions or contact us directly for help.',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                  SizedBox(height: 24),

                  _SectionCard(
                    title: 'Contact Us',
                    rows: [
                      _CardRow(
                        leading: 'Live Chat',
                        value: 'Available 24/7 directly in the app.',
                      ),
                      _CardRow.divider(),
                      _CardRow(
                        leading: 'Phone Support',
                        value: 'Call us at 1-800-123-4567, Mon–Fri, 8 AM–8 PM EST.',
                      ),
                      _CardRow.divider(),
                      _CardRow(
                        leading: 'Email Support',
                        value: 'Reach us at support@[appname].com.',
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  _SectionCard(
                    title: 'Delivery & Returns',
                    rows: [
                      _CardRow(
                        leading: 'Delivery Area',
                        value: 'Available in most areas within [State(s)].',
                      ),
                      _CardRow.divider(),
                      _CardRow(
                        leading: 'Returns',
                        value: 'Return items within 7 days for a full refund.',
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  _SectionCard(
                    title: 'Account & Privacy',
                    rows: [
                      _CardRow(
                        leading: 'Update Info',
                        value: 'Change your details in the profile settings.',
                      ),
                      _CardRow.divider(),
                      _CardRow(
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

      /// ===== Floating chat button (64x64, shadow, exact color) =====
      floatingActionButton: Padding(
        // nudged a bit inward to match figma placement
        padding: const EdgeInsets.only(bottom: 10, right: 6),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            // figma shadow: 0,4,16, #15224F @ 10% (0x1915224F)
            boxShadow: const [
              BoxShadow(
                color: Color(0x1915224F),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: FloatingActionButton(
            onPressed: _openLiveChat,
            elevation: 0,
            backgroundColor: const Color(0xFF33595B),
            shape: const CircleBorder(),
            child: const Icon(Icons.support_agent, size: 30, color: Colors.white),
          ),
        ),
      ),

      /// ===== Bottom nav (on in comps) =====
      // If your app uses FFBottomNav, keep this enabled to match the mock.
      bottomNavigationBar:
      FFBottomNav(currentIndex: _tab, onTap: (i) => setState(() => _tab = i)),
    );
  }
}

/// =============== Small building blocks (exact to Figma) ===============

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.rows});
  final String title;
  final List<_CardRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Card: white, radius 8, padding 16, divider color E0E0E0
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title: 16 / 600 / #212121
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: const Color(0xFFE0E0E0)),
          const SizedBox(height: 16),
          // Rows with 16 vertical spacing (“spacing: 16” in plugin)
          ..._intersperse(rows.where((r) => !r.isDivider).toList(), const SizedBox(height: 16)),
          // we draw internal dividers via individual _CardRow.divider() widgets:
          ...rows.where((r) => r.isDivider),
        ],
      ),
    );
  }

  // helper to add spacing between non-divider rows
  static List<Widget> _intersperse(List<_CardRow> items, Widget spacer) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) out.add(spacer);
    }
    return out;
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    this.leading,
    this.value,
    this.isDivider = false,
  });

  final String? leading;
  final String? value;
  final bool isDivider;

  /// A divider row inside the card with exact color/height from Figma
  const _CardRow.divider()
      : leading = null,
        value = null,
        isDivider = true;

  @override
  Widget build(BuildContext context) {
    if (isDivider) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(height: 1, color: const Color(0xFFE0E0E0)),
      );
    }

    // Text system: 14 size, label 500, value 400, #212121, lh 1.43
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$leading: ',
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}
