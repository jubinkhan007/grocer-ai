import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart'; // if you still need AppColors

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _openLiveChat() {
    Get.snackbar('Live chat', 'Hook me up to your live chat when ready.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),

      body: CustomScrollView(
        slivers: [
          // ===== Top app bar =====
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF33595B),
            collapsedHeight: 117,
            expandedHeight: 117,
            titleSpacing: 0,
            title: Container(
              color: const Color(0xFF33595B),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    // back button should actually pop this route
                    IconButton(
                      padding: EdgeInsets.zero,
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: Get.back,
                    ),
                    const SizedBox(width: 8),
                    const Text(
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

          // ===== Body =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
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

      // FAB (chat)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 6),
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            boxShadow: [
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
            child: const Icon(
              Icons.support_agent,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),

      // ⛔️ IMPORTANT: no bottomNavigationBar here.
    );
  }
}

/// ===== helper widgets =====

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.rows});
  final String title;
  final List<_CardRow> rows;

  @override
  Widget build(BuildContext context) {
    // we render rows manually to preserve figma spacing/dividers
    final contentRows = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isDivider) {
        contentRows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(height: 1, color: const Color(0xFFE0E0E0)),
          ),
        );
      } else {
        if (i != 0 && !rows[i - 1].isDivider) {
          contentRows.add(const SizedBox(height: 16));
        }
        contentRows.add(row);
      }
    }

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
          ...contentRows,
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
    if (isDivider) {
      // handled in _SectionCard above
      return const SizedBox.shrink();
    }

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
