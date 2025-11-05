import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart'; // only for colors elsewhere if you need

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // If you already wired the copilot sheet, call that here instead.
  void _openLiveChat(BuildContext context) {
    // showCopilotSheet(context);  // <- uncomment if you use the sheet provided
    Get.snackbar('Live chat', 'Hook me up to your live chat when ready.');
  }





  @override
  Widget build(BuildContext context) {
    const _bg = Color(0xFFF4F6F6);
    const _teal = Color(0xFF33595B);
    const _divider = Color(0xFFE0E0E0);
    final padTop = MediaQuery.of(context).padding.top;
    const _toolbar = 63.0;

    return Scaffold(
      backgroundColor: _bg,

      // ===== BODY =====
      body: CustomScrollView(
        slivers: [
          /// Top app bar (48 status + 68 toolbar = 116)
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: _teal,

            // total height = status bar + 56 (matches standard Figma toolbars)
            collapsedHeight:  _toolbar,
            expandedHeight: _toolbar,

            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              color: _teal,
              padding: EdgeInsets.only(top: padTop), // only cover the notch area
              child: SizedBox(
                height: _toolbar,
                child: Row(
                  children: const [
                    SizedBox(width: 0),
                    _BackChevron(), // 20px icon already sized correctly
                    SizedBox(width: 0),
                    Text(
                      'Help & Support',
                      style: TextStyle(
                        color: Color(0xFFFEFEFE),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Content
          SliverToBoxAdapter(
            child: Padding(
              // NOTE: bottom padding keeps content above the nav bar + FAB area.
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'We’re here to assist you! Find quick answers to your questions or contact us directly for help.',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                      fontFamily: 'Roboto',
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
                        value:
                        'Call us at 1-800-123-4567, Mon–Fri, 8 AM–8 PM EST.',
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

      /// ===== FAB (64x64 with shadow) =====
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        // matches the mock’s ~10px bottom & ~6px right visual gap
        padding: const EdgeInsets.only(bottom: 10, right: 6),
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1915224F),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: _teal,
            shape: const CircleBorder(),
            onPressed: () => _openLiveChat(context),
            child: const Icon(Icons.support_agent, color: Colors.white, size: 30),
          ),
        ),
      ),

      /// ===== Bottom bar (exact layout & shadow) =====
      // bottomNavigationBar: const _HelpBottomBar(),
    );
  }
}

/// back chevron sized like the mock (14×20 visual)
class _BackChevron extends StatelessWidget {
  const _BackChevron();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      splashRadius: 22,
      onPressed: Get.back,
      icon: const Icon(Icons.arrow_back_ios_new_rounded,
          color: Color(0xFFFEFEFE), size: 20),
    );
  }
}

/// ===== Section card exactly as in Figma (title 14/700, divider, paddings) =====
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.rows});
  final String title;
  final List<_CardRow> rows;

  @override
  Widget build(BuildContext context) {
    const _divider = Color(0xFFE0E0E0);

    final content = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      final r = rows[i];
      if (r.isDivider) {
        content.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(height: 1, color: _divider),
          ),
        );
      } else {
        if (i != 0 && !rows[i - 1].isDivider) {
          content.add(const SizedBox(height: 16));
        }
        content.add(r);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 0),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14, // Figma plugin: 14
              fontWeight: FontWeight.w700, // Figma plugin: 700
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: _divider),
          const SizedBox(height: 16),
          ...content,
        ],
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({this.leading, this.value, this.isDivider = false});
  final String? leading;
  final String? value;
  final bool isDivider;

  const _CardRow.divider() : leading = null, value = null, isDivider = true;

  @override
  Widget build(BuildContext context) {
    if (isDivider) return const SizedBox.shrink();

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$leading: ',
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.43,
              fontFamily: 'Roboto',
            ),
          ),
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Color(0xFF212121),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.43,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom bar drawn like the mock (white, top shadow, icons 24, active=Help)
class _HelpBottomBar extends StatelessWidget {
  const _HelpBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFEFEFE),
        boxShadow: [
          BoxShadow(
            color: Color(0x2833595B), // same translucent teal shadow in Figma
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _BarIcon(icon: Icons.home_outlined),
          _BarIcon(icon: Icons.percent_outlined),
          _BarIcon(icon: Icons.shopping_bag_outlined),
          _BarActive(), // “Help” active exactly like the mock
          _BarIcon(icon: Icons.person_outline),
        ],
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  const _BarIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Icon(icon, size: 24, color: Color(0xFF9AA4A6)),
      ),
    );
  }
}

/// Center “Help” tile matches the highlighted look in the screenshot.
class _BarActive extends StatelessWidget {
  const _BarActive();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            // small rounded 8 container around the icon (subtle)
            SizedBox(
              height: 36,
              child: Center(
                child: Icon(Icons.support_agent, size: 24, color: Color(0xFF33595B)),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Help',
              style: TextStyle(
                color: Color(0xFF33595B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
