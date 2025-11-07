// lib/features/profile/transactions/transactions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // <-- 1. IMPORT
import 'package:grocer_ai/features/profile/transactions/transaction_details_screen.dart';
import 'model/transaction_model.dart';
import 'transaction_controller.dart'; // <-- 3. IMPORT

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

// --- 4. ADD NEW PILL COLORS ---
const _pillFailedBg = Color(0xFFF7E4DD);
const _pillFailedText = Color(0xFFBA4012);
const _pillPendingBg = Color(0xFFFEF1D7);
const _pillPendingText = Color(0xFF956703);

const _cardBg = Color(0xFFFEFEFE);
const _avatarBg = Color(0xFFF4F6F6);

// --- 5. MODIFIED: Converted to GetView<TransactionController> ---
class TransactionsScreen extends GetView<TransactionController> {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _tealStatus,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    // --- 6. REMOVED static groups list ---

    return Container(
      color: _bgPage,
      child: Column(
        children: [
          const _TransactionsHeader(),

          // --- 7. MODIFIED: Added Obx for loading/empty/data states ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.groupedTransactions.isEmpty) {
                return const Center(child: Text('No transactions found.'));
              }

              final groupKeys = controller.groupedTransactions.keys.toList();

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  24 + 80,
                ),
                itemCount: groupKeys.length,
                itemBuilder: (context, groupIndex) {
                  final dateLabel = groupKeys[groupIndex];
                  final items = controller.groupedTransactions[dateLabel]!;

                  return _TransactionGroupSection(
                    dateLabel: dateLabel, // <-- Pass dynamic date
                    items: items, // <-- Pass dynamic list
                    isLast: groupIndex == groupKeys.length - 1,
                    onItemTap: (txItem) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TransactionDetailScreen(
                            // <-- Pass dynamic ID
                            transactionId: txItem.id.toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ... (_TransactionsHeader remains the same) ...
class _TransactionsHeader extends StatelessWidget {
  const _TransactionsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: _tealStatus,
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: SafeArea(
            bottom: false,
            child: const SizedBox(height: 0),
          ),
        ),
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

// --- 8. MODIFIED: _TransactionGroupSection to accept model ---
class _TransactionGroupSection extends StatelessWidget {
  const _TransactionGroupSection({
    required this.dateLabel,
    required this.items,
    required this.isLast,
    required this.onItemTap,
  });

  final String dateLabel;
  final List<ProfilePaymentTransaction> items; // <-- Use model
  final bool isLast;
  final void Function(ProfilePaymentTransaction) onItemTap; // <-- Use model

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateLabel, // <-- Use dynamic label
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
              for (int i = 0; i < items.length; i++) ...[
                _TransactionCard(
                  item: items[i], // <-- Pass item
                  onTap: () => onItemTap(items[i]),
                ),
                if (i != items.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// --- 9. MODIFIED: _TransactionCard to accept model ---
class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.item,
    required this.onTap,
  });

  final ProfilePaymentTransaction item; // <-- Use model
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                // TODO: plug in brand logos here
                child: const Icon(
                  Icons.store_mall_directory_rounded,
                  size: 24,
                  color: _tealHeader,
                ),
              ),
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
                            // <-- Use dynamic data
                            item.order.id
                                .toString(), // API doesn't send store name here
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
                          '\$${item.amount}', // <-- Use dynamic data
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatusPill(statusKey: item.status), // <-- Use dynamic data
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.userPaymentMethod.displayName, // <-- Use dynamic data
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

// --- 10. MODIFIED: _StatusPill to accept string key and handle all cases ---
class _StatusPill extends StatelessWidget {
  final String statusKey; // 'pending', 'paid', 'failed', 'refunded'
  const _StatusPill({required this.statusKey});

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color fgColor, String label) = switch (statusKey) {
      'paid' => (_pillCompletedBg, _pillCompletedText, 'Completed'),
      'failed' => (_pillFailedBg, _pillFailedText, 'Failed'),
      'cancelled' => (_pillCancelledBg, _pillCancelledText, 'Cancelled'),
      'refunded' => (_pillCancelledBg, _pillCancelledText, 'Refunded'),
      _ => (_pillPendingBg, _pillPendingText, 'Pending'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fgColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.2,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

// --- 11. REMOVED static model classes _TxStatus, _TxItem, _TxGroup ---