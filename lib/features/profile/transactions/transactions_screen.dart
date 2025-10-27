import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ai/features/profile/transactions/transaction_details_screen.dart';

const _bgPage = Color(0xFFF4F6F6);
const _tealStatus = Color(0xFF002C2E);
const _tealHeader = Color(0xFF33595B);

const _textPrimary = Color(0xFF212121);
const _textHeading = Color(0xFF001415);
const _textStore = Color(0xFF33595B);
const _textMethod = Color(0xFF4D4D4D);

const _pillCompletedBg = Color(0xFFE2F2E9);
const _pillCompletedText = Color(0xFF3E8D5E);

const _pillCancelledBg = Color(0xFFF7E4DD);
const _pillCancelledText = Color(0xFFBA4012);

const _cardBg = Color(0xFFFEFEFE);
const _avatarBg = Color(0xFFF4F6F6);

// ------------------------------------------------------------
// IMPORTANT: no Scaffold here.
// This widget is meant to live INSIDE MainShell's Profile tab
// ------------------------------------------------------------
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // keep Figma status bar styling
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _tealStatus,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    final groups = <_TxGroup>[
      _TxGroup(
        '22 Sep 2024',
        const [
          _TxItem(
            store: 'Kroger',
            amount: '\$321',
            method: 'Apple Pay',
            status: _TxStatus.completed,
          ),
          _TxItem(
            store: 'Kroger',
            amount: '\$321',
            method: 'Apple Pay',
            status: _TxStatus.completed,
          ),
          _TxItem(
            store: 'Aldi',
            amount: '\$654',
            method: 'Google Pay',
            status: _TxStatus.cancelled,
          ),
          _TxItem(
            store: 'Walmart',
            amount: '\$234',
            method: 'Credit Card',
            status: _TxStatus.completed,
          ),
        ],
      ),
      _TxGroup(
        '12 Sep 2024',
        const [
          _TxItem(
            store: 'Walmart',
            amount: '\$789',
            method: 'Credit Card',
            status: _TxStatus.cancelled,
          ),
          _TxItem(
            store: 'Aldi',
            amount: '\$456',
            method: 'Google Pay',
            status: _TxStatus.completed,
          ),
          _TxItem(
            store: 'Kroger',
            amount: '\$987',
            method: 'Apple Pay',
            status: _TxStatus.completed,
          ),
          _TxItem(
            store: 'Walmart',
            amount: '\$789',
            method: 'Credit Card',
            status: _TxStatus.cancelled,
          ),
          _TxItem(
            store: 'Walmart',
            amount: '\$234',
            method: 'Credit Card',
            status: _TxStatus.completed,
          ),
        ],
      ),
    ];

    return Container(
      color: _bgPage,
      child: Column(
        children: [
          const _TransactionsHeader(),

          // scroll body
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24 + 80, // leave space so FFBottomNav (from shell) doesn't overlap
              ),
              itemCount: groups.length,
              itemBuilder: (context, groupIndex) {
                final group = groups[groupIndex];
                return _TransactionGroupSection(
                  group: group,
                  isLast: groupIndex == groups.length - 1,
                  onItemTap: (txItem) {
                    // push detail screen into THIS tab's navigator
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TransactionDetailScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// HEADER stays exactly the same UI you already built
class _TransactionsHeader extends StatelessWidget {
  const _TransactionsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // dark 48px strip behind status icons
        Container(
          color: _tealStatus,
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: SafeArea(
            bottom: false,
            child: const SizedBox(height: 0),
          ),
        ),

        // teal toolbar (63px high in figma)
        Container(
          width: double.infinity,
          height: 63,
          color: _tealHeader,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Color(0xFFFEFEFE),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Transaction',
                  style: TextStyle(
                    color: Color(0xFFFEFEFE),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ====== the rest of the helper widgets (unchanged visually) ======

class _TransactionGroupSection extends StatelessWidget {
  const _TransactionGroupSection({
    required this.group,
    required this.isLast,
    required this.onItemTap,
  });

  final _TxGroup group;
  final bool isLast;
  final void Function(_TxItem) onItemTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.dateLabel,
            style: const TextStyle(
              color: _textHeading,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.3,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              for (int i = 0; i < group.items.length; i++) ...[
                _TransactionCard(
                  item: group.items[i],
                  onTap: () => onItemTap(group.items[i]),
                ),
                if (i != group.items.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.item,
    required this.onTap,
  });

  final _TxItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // leading square 48x48
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                // TODO: plug in brand logos here
                child: item.logo ??
                    const Icon(
                      Icons.store_mall_directory_rounded,
                      size: 24,
                      color: _tealHeader,
                    ),
              ),
              const SizedBox(width: 16),

              // right block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // merchant + amount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.store,
                            style: const TextStyle(
                              color: _textStore,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        Text(
                          item.amount,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // status pill + method aligned right
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatusPill(status: item.status),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.method,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: _textMethod,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final _TxStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == _TxStatus.completed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isCompleted ? _pillCompletedBg : _pillCancelledBg,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        isCompleted ? 'Completed' : 'Cancelled',
        style: TextStyle(
          color: isCompleted ? _pillCompletedText : _pillCancelledText,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.2,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

// tiny value objects
enum _TxStatus { completed, cancelled }

class _TxItem {
  final String store;
  final String amount;
  final String method;
  final _TxStatus status;
  final Widget? logo;
  const _TxItem({
    required this.store,
    required this.amount,
    required this.method,
    required this.status,
    this.logo,
  });
}

class _TxGroup {
  final String dateLabel;
  final List<_TxItem> items;
  const _TxGroup(this.dateLabel, this.items);
}
