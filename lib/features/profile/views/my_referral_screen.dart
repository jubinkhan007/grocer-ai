// lib/features/profile/views/my_referral_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/profile/controllers/referral_controller.dart';
import 'package:grocer_ai/features/profile/models/referral_model.dart';
import 'package:grocer_ai/features/profile/views/referral_success_dialog.dart';
import 'package:intl/intl.dart';

import 'invite_friends_screen.dart';

// ... (Design tokens remain the same) ...
const _bgPage = Color(0xFFF4F6F6);
const _tealStatus = Color(0xFF002C2E);
const _tealHeader = Color(0xFF33595B);
const _cardBg = Color(0xFFFEFEFE);
const _nameText = _tealHeader;
const _timeText = Color(0xFF4D4D4D);
const _dayHeading = Color(0xFF001415);
const _chipJoinedBg = Color(0xFFE2F2E9);
const _chipJoinedText = Color(0xFF3E8D5E);
const _chipCancelledBg = Color(0xFFF7E4DD);
const _chipCancelledText = Color(0xFFBA4012);
const _chipInvitedBg = Color(0xFFFEF1D7);
const _chipInvitedText = Color(0xFF956703);
const _dividerShadow = Color(0x2833595B);

class MyReferralScreen extends GetView<ReferralController> {
  const MyReferralScreen({super.key});

  Map<String, List<Referral>> _groupReferrals(List<Referral> referrals) {
    final groups = <String, List<Referral>>{};
    final formatter = DateFormat('dd MMM yyyy');
    for (final ref in referrals) {
      DateTime? dt = ref.createdAt; // <-- Now uses createdAt from model

      final dateString = dt != null ? formatter.format(dt) : "Unknown Date";

      if (groups.containsKey(dateString)) {
        groups[dateString]!.add(ref);
      } else {
        groups[dateString] = [ref];
      }
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _tealStatus,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: _bgPage,
      body: Column(
        children: [
          // ... (TOP STRIP and HEADER BAR remain the same) ...
          Container(
            color: _tealStatus,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: media.padding.top,
              bottom: 12,
              left: 24,
              right: 24,
            ),
          ),
          Container(
            color: _tealHeader,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // --- Dynamic List Content ---
          Expanded(
            child: Container(
              color: _bgPage,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.referrals.isEmpty) {
                  return const Center(child: Text('You have no referrals yet.'));
                }

                final grouped = _groupReferrals(controller.referrals);
                final dateKeys = grouped.keys.toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    24,
                    24,
                    120,
                  ),
                  itemCount: dateKeys.length,
                  itemBuilder: (context, index) {
                    final dateLabel = dateKeys[index];
                    final entries = grouped[dateLabel]!;
                    return _ReferralDaySection(
                      dateLabel: dateLabel,
                      entries: entries, // Pass the dynamic list
                    );
                  },
                );
              }),
            ),
          ),

          // ... (bottom nav shadow "bleed" remains the same) ...
          Container(
            height: media.padding.bottom,
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

class _ReferralDaySection extends StatelessWidget {
  final String dateLabel;
  final List<Referral> entries;
  const _ReferralDaySection({
    required this.dateLabel,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

// ... (_ReferralStatusKind and _ReferralStatusChip remain the same) ...
enum _ReferralStatusKind { joined, cancelled, invited }

_ReferralStatusKind _kindFromKey(String key) {
  switch (key.toLowerCase()) {
    case 'joined':
    case 'completed': // API uses 'completed'
      return _ReferralStatusKind.joined;
    case 'cancelled':
      return _ReferralStatusKind.cancelled;
    case 'invited':
    default:
      return _ReferralStatusKind.invited;
  }
}

class _ReferralStatusChip extends StatelessWidget {
  final String label;
  final _ReferralStatusKind kind;
  const _ReferralStatusChip({
    required this.label,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
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
      default:
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
        label.capitalizeFirst ?? label,
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

class _ReferralRow extends StatelessWidget {
  final Referral data;
  const _ReferralRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final time = data.createdAt != null
        ? DateFormat('h:mma').format(data.createdAt!)
        : '';
    final amount = '\$${data.amount.toStringAsFixed(0)}';
    final statusKind = _kindFromKey(data.status);
    final cleanAmount = data.amount.toStringAsFixed(0);

    // --- THIS IS THE FIX for Error 2 ---
    final String? avatarUrl = data.avatar;
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    // --- END FIX ---

    // Use the referred user's name, fallback to the invited name/email
    final String displayName = data.referred.name ?? data.name ?? data.referred.email;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        if (data.amount > 0) {
          showReferralCongratsDialog(
            context,
            amountEarned: cleanAmount,
          );
        }
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
            // --- MODIFIED: Safely use dynamic avatar URL ---
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                image: hasAvatar
                    ? DecorationImage(
                  image: NetworkImage(avatarUrl!),
                  fit: BoxFit.cover,
                  onError: (e, s) => {},
                )
                    : null,
              ),
              child: !hasAvatar
                  ? Icon(Icons.person, size: 24, color: Colors.grey.shade600)
                  : null,
            ),
            // --- END MODIFICATION ---
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          displayName, // <-- Use dynamic name
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
                        amount,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          time,
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
                        label: data.status,
                        kind: statusKind,
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

// ... (showReferralCongratsDialog remains the same) ...
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
            onClose: () {
              Navigator.of(dialogContext).pop();
            },
            onInviteAnother: () {
              Navigator.of(dialogContext).pop();
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