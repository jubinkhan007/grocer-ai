import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ai/features/profile/views/referral_success_dialog.dart';

import 'invite_friends_screen.dart';

/// ---------- DESIGN TOKENS (from Figma) ----------

const _bgPage = Color(0xFFF4F6F6); // page background
const _tealStatus = Color(0xFF002C2E); // very top system bar strip
const _tealHeader = Color(0xFF33595B); // header bar and primary text teal

const _cardBg = Color(0xFFFEFEFE); // row card bg
const _nameText = _tealHeader; // referral name + $189 color
const _timeText = Color(0xFF4D4D4D); // 14px secondary row text
const _dayHeading = Color(0xFF001415); // "22 Sep 2024" etc.

const _chipJoinedBg = Color(0xFFE2F2E9);
const _chipJoinedText = Color(0xFF3E8D5E);

const _chipCancelledBg = Color(0xFFF7E4DD);
const _chipCancelledText = Color(0xFFBA4012);

const _chipInvitedBg = Color(0xFFFEF1D7);
const _chipInvitedText = Color(0xFF956703);

const _dividerShadow = Color(0x2833595B); // bottom nav bar drop shadow

/// ---------- PUBLIC SCREEN WIDGET ----------

class MyReferralScreen extends StatelessWidget {
  const MyReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // match light icons on dark status background like figma
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _tealStatus,
      statusBarIconBrightness: Brightness.light, // Android status icons
      statusBarBrightness: Brightness.dark, // iOS status icons are light on dark bg
    ));

    final media = MediaQuery.of(context);

    return Scaffold(
      // Don't provide a bottomNavigationBar here since your shell already does it.
      backgroundColor: _bgPage,
      body: Column(
        children: [
          /// -------- TOP STRIP (tealStatus) ----------
          /// In your screenshot this is ~48px tall and full tealStatus behind iOS status stuff.
          Container(
            color: _tealStatus,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: media.padding.top, // notch / dynamic island spacing
              bottom: 12,
              left: 24,
              right: 24,
            ),
            // We are intentionally NOT recreating battery/wifi/time here.
            // The real device paints that. We just give the dark bg.
          ),

          /// -------- HEADER BAR (tealHeader) ----------
          Container(
            color: _tealHeader,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // back chevron 14x20 in figma, but give a 24x24 tap target
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'My referral',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Figma shows 20 bold-ish
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                // spacer to push anything you *might* add on RHS later
              ],
            ),
          ),

          /// -------- LIST CONTENT (scrolls under header) ----------
          Expanded(
            child: Container(
              color: _bgPage,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24, // top spacing between header & first date section
                  24,
                  120, // breathing room above bottom nav bar
                ),
                children: const [
                  _ReferralDaySection(
                    dateLabel: '22 Sep 2024',
                    entries: [
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Sophia Williams',
                        time: '11:00am',
                        amount: '\$189',
                        statusText: 'Joined',
                        statusKind: _ReferralStatusKind.joined,
                      ),
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Olivia Brown',
                        time: '7:50pm',
                        amount: '\$189',
                        statusText: 'Cancelled',
                        statusKind: _ReferralStatusKind.cancelled,
                      ),
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Mason Brown',
                        time: '8:20am',
                        amount: '\$189',
                        statusText: 'Cancelled',
                        statusKind: _ReferralStatusKind.cancelled,
                      ),
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Liam Smith',
                        time: '8:20am',
                        amount: '\$189',
                        statusText: 'Invited',
                        statusKind: _ReferralStatusKind.invited,
                      ),
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Emily Johnson',
                        time: '2:30pm',
                        amount: '\$189',
                        statusText: 'Joined',
                        statusKind: _ReferralStatusKind.joined,
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  _ReferralDaySection(
                    dateLabel: '12 Sep 2024',
                    entries: [
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Emily Johnson',
                        time: '2:30pm',
                        amount: '\$189',
                        statusText: 'Joined',
                        statusKind: _ReferralStatusKind.joined,
                      ),
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Ava Davis',
                        time: '3:05pm',
                        amount: '\$189',
                        statusText: 'Joined',
                        statusKind: _ReferralStatusKind.joined,
                      ),
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Liam Johnson',
                        time: '4:15pm',
                        amount: '\$189',
                        statusText: 'Invited',
                        statusKind: _ReferralStatusKind.invited,
                      ),
                      _ReferralEntryData(
                        avatarUrl: 'https://placehold.co/48x48',
                        name: 'Olivia Carter',
                        time: '2:30pm',
                        amount: '\$189',
                        statusText: 'Joined',
                        statusKind: _ReferralStatusKind.joined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// -------- bottom nav shadow "bleed"
          /// You already render the true BottomNav in your shell.
          /// That nav has a white bg + upward shadow (0,-4 blur12 rgba(51,89,91,0.16)).
          /// We just paint a matching translucent fade behind it so scrolling
          /// content doesn't peek through.
          Container(
            height: media.padding.bottom, // mostly 0 on iOS sim except home bar
            decoration: const BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: _dividerShadow,
                  blurRadius: 12,
                  offset: Offset(0, -4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- DAY SECTION (e.g. "22 Sep 2024" + list of rows) ----------

class _ReferralDaySection extends StatelessWidget {
  final String dateLabel;
  final List<_ReferralEntryData> entries;
  const _ReferralDaySection({
    required this.dateLabel,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date heading "22 Sep 2024"
        Text(
          dateLabel,
          style: const TextStyle(
            color: _dayHeading,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),

        // List of entry cards — each 8px radius, white bg, 16 horizontal, 12 vertical,
        // separated by 16px vertical gap
        Column(
          children: [
            for (int i = 0; i < entries.length; i++) ...[
              _ReferralRow(data: entries[i]),
              if (i != entries.length - 1) const SizedBox(height: 16),
            ],
          ],
        ),
      ],
    );
  }
}

/// ---------- DATA MODEL FOR A ROW (simple struct) ----------

class _ReferralEntryData {
  final String avatarUrl;
  final String name;
  final String time;
  final String amount;
  final String statusText;
  final _ReferralStatusKind statusKind;

  const _ReferralEntryData({
    required this.avatarUrl,
    required this.name,
    required this.time,
    required this.amount,
    required this.statusText,
    required this.statusKind,
  });
}

enum _ReferralStatusKind { joined, cancelled, invited }

/// ---------- STATUS CHIP WIDGET (Joined / Cancelled / Invited) ----------

class _ReferralStatusChip extends StatelessWidget {
  final String label;
  final _ReferralStatusKind kind;

  const _ReferralStatusChip({
    required this.label,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    // map kind -> bg/text colors from Figma
    Color bg;
    Color fg;
    switch (kind) {
      case _ReferralStatusKind.joined:
        bg = _chipJoinedBg;
        fg = _chipJoinedText;
        break;
      case _ReferralStatusKind.cancelled:
        bg = _chipCancelledBg;
        fg = _chipCancelledText;
        break;
      case _ReferralStatusKind.invited:
        bg = _chipInvitedBg;
        fg = _chipInvitedText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(40),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
      ),
    );
  }
}

/// ---------- SINGLE REFERRAL ROW CARD ----------
/// Layout per Figma:
///  - Card radius 8, white
///  - Vertical padding 12, horizontal padding 16
///  - Leading avatar 48x48 round
///  - Beside that: name + $amount (same baseline row)
///                 time + status chip (row below)
///
/// Typography:
///  name     16 / w600 / #33595B
///  $189     16 / w600 / #33595B
///  time     14 / w400 / #4D4D4D
///  status   chip styles per kind
class _ReferralRow extends StatelessWidget {
  final _ReferralEntryData data;
  const _ReferralRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // big rounded hit region just like you'd expect on iOS lists
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        // we’ll strip the $ just for nicer dialog text,
        // since the dialog wants just "50" etc.
        final cleanAmount = data.amount.replaceAll('\$', '');

        showReferralCongratsDialog(
          context,
          amountEarned: cleanAmount,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // avatar 48x48 circular
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(data.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // main text column fills remaining space
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// top row: name (left)  |  amount (right)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name
                      Expanded(
                        child: Text(
                          data.name,
                          style: const TextStyle(
                            color: _nameText,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data.amount,
                        style: const TextStyle(
                          color: _nameText,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  /// bottom row: time (left) | status chip (right)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          data.time,
                          style: const TextStyle(
                            color: _timeText,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ReferralStatusChip(
                        label: data.statusText,
                        kind: data.statusKind,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> showReferralCongratsDialog(
    BuildContext context, {
      required String amountEarned,
    }) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Referral Congrats',
    barrierColor: Colors.black.withOpacity(0.45),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (dialogContext, anim, __, ___) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return Opacity(
        opacity: curved.value,
        child: Transform.scale(
          scale: 0.95 + (0.05 * curved.value),
          child: ReferralCongratsDialog(
            amountEarned: amountEarned,

            //  CLOSE (X) button
            onClose: () {
              Navigator.of(dialogContext).pop(); // just dismiss
            },

            //  "Invite another" button
            onInviteAnother: () {
              // 1. close the dialog
              Navigator.of(dialogContext).pop();

              // 2. push the InviteFriendsScreen
              Navigator.of(dialogContext).push(
                MaterialPageRoute(
                  builder: (_) => const InviteFriendsScreen(),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
