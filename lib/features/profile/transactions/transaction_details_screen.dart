import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:grocer_ai/features/profile/transactions/transaction_controller.dart';

import '../../shared/teal_app_bar.dart';
import 'model/transaction_model.dart';

/// ---------------------------------------------------------------------------
/// PALETTE + TYPO
/// ---------------------------------------------------------------------------

class _Palette {
  // Surfaces
  static const bgScreen = Color(0xFFF4F6F6); // page background
  static const bgCard = Color(0xFFFEFEFE); // cards
  static const bgChip = Color(0xFFF4F6F6); // 48x48 icon bg in list rows
  static const bgStatusBar = Color(0xFF002C2E); // dark strip behind 9:41
  static const bgHeaderBar = Color(0xFF33595B); // teal header
  static const bottomNavBg = Color(0xFFFEFEFE);

  // Text
  static const textOnHeader = Color(0xFFFEFEFE); // white-ish
  static const textTitlePrimary = Color(0xFF001415); // section headers “Transaction details”
  static const textRowLabel = Color(0xFF212121); // “Card number”
  static const textRowValue = Color(0xFF4D4D4D); // grey right side
  static const textBullet = Color(0xFF8AA0A1);

  // Borders / dividers
  static const rowDivider = Color(0xFFE9E9E9);
  static const vDivider = Color(0xFFDEE0E0);

  // Quantity pills
  static const qtyPillBg = Color(0xFFE6EAEB);
  static const qtyPillBorder = Color(0xFF33595B);

  // Shadows (the subtle pink-ish card shadow on price block / bottom nav bar shadow)
  static const priceShadow = Color(0x19EF4D75); // rgba-ish in design
  static const bottomBarShadow = Color(0x2833595B); // rgba-ish in design
}

class _TextStyles {
  // Header title "TXN ID: #565765"
  static const headerTitle = TextStyle(
    color: _Palette.textOnHeader,
    fontSize: 20,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // Section heading "Transaction details", "Order list"
  static const sectionHeading = TextStyle(
    color: _Palette.textTitlePrimary,
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Row label on left (Card number / Transfer number / etc)
  static const detailsLabel = TextStyle(
    color: _Palette.textRowLabel,
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Row value on right (numbers, date, Walmart, $400)
  static const detailsValue = TextStyle(
    color: _Palette.textRowValue,
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // Order item title ("Royal Basmati Rice")
  static const itemTitle = TextStyle(
    color: _Palette.textRowLabel,
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Order item meta row ("$8.75 per kg • $39.3 total")
  static const itemMeta = TextStyle(
    color: _Palette.textRowValue,
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // Right side price in each order card ("$28.75")
  static const itemAmt = TextStyle(
    color: _Palette.textRowLabel,
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Right side "3 Item"
  static const itemQtyLine = TextStyle(
    color: _Palette.textRowValue,
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // Quantity number ("2", "5")
  static const qtyNumber = TextStyle(
    color: _Palette.textRowLabel,
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Fake iOS status bar "9:41"
  static const fakeStatusBarText = TextStyle(
    color: Color(0xFFE9E9E9),
    fontSize: 16.41,
    fontFamily: 'SF Pro Text',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.18,
    height: 1.0,
  );

  // Bottom nav label "Profile"
  static const bottomNavLabelSelected = TextStyle(
    color: _Palette.bgHeaderBar,
    fontSize: 12,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}

/// ---------------------------------------------------------------------------
/// ROOT SCREEN
/// ---------------------------------------------------------------------------

class TransactionDetailScreen extends StatefulWidget {
  final String transactionId;
  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final TransactionController controller = Get.find<TransactionController>();
  bool _fired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fire exactly once so we hit: GET /api/v1/profile/transactions/{id}/
    if (!_fired) {
      _fired = true;
      // safe to call after first build context exists
      controller.loadTransactionDetail(widget.transactionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ProfilePaymentTransaction? tx =
          controller.detail.value ??
              controller.transactions.firstWhereOrNull(
                    (t) => t.id.toString() == widget.transactionId,
              );

      if (tx == null && controller.isDetailLoading.value) {
        return const Scaffold(
          backgroundColor: _Palette.bgScreen,
          body: Center(child: CircularProgressIndicator()),
        );
      }
      if (tx == null) {
        return const Scaffold(
          backgroundColor: _Palette.bgScreen,
          body: Center(child: Text('Transaction not found.')),
        );
      }

      // ✅ No fake status bar; just the teal header inside SafeArea
      return Scaffold(
        backgroundColor: _Palette.bgScreen,
        appBar: TealTitleAppBar(
          title: (tx.transactionId != null && tx.transactionId!.isNotEmpty)
              ? 'TXN ID: ${tx.transactionId}'
              : 'TXN ID: #${tx.id}',
          showBack: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transaction details', style: _TextStyles.sectionHeading),
              const SizedBox(height: 16),
              _TransactionDetailsCard(tx: tx),
              const SizedBox(height: 24),

              Text('Order list', style: _TextStyles.sectionHeading),
              const SizedBox(height: 16),

              // (Your demo items unchanged)
              const _OrderListItemPriceOnly(
                title: 'Royal Basmati Rice',
                metaLeft: '\$8.75 per kg',
                metaRight: '\$39.3 total',
                amountText: '\$28.75',
                itemsText: '3 Item',
              ),
              const SizedBox(height: 16),
              const _OrderListItemPriceOnly(
                title: 'Sunny Valley Olive Oil',
                metaLeft: '\$75.30 per barrel',
                metaRight: '\$23.8 total',
                amountText: '\$28.75',
                itemsText: '3 Item',
              ),
              const SizedBox(height: 16),
              const _OrderListItemPriceOnly(
                title: 'Golden Harvest Quinoa',
                metaLeft: '\$4.29 unit price',
                metaRight: '\$42.7 total',
                amountText: '\$28.75',
                itemsText: '3 Item',
              ),
              const SizedBox(height: 16),
              const _OrderListItemWithQty(
                title: 'Blue Mountain Coffee Beans',
                metaLeft: '\$12.99 unit price',
                metaRight: '\$19.6 total',
                qtyText: '2',
              ),
              const SizedBox(height: 16),
              const _OrderListItemWithQty(
                title: 'Silver Lake Almond Milk',
                metaLeft: '\$3.50 per gallon',
                metaRight: '\$27.2 total',
                qtyText: '5',
              ),
              const SizedBox(height: 16),
              const _OrderListItemWithQty(
                title: 'Sunrise Organic Oats',
                metaLeft: '\$5.50 unit price',
                metaRight: '\$34.5 total',
                qtyText: '2',
              ),
              const SizedBox(height: 16),
              const _OrderListItemWithQty(
                title: 'Wholesome Valley Granola',
                metaLeft: '\$8.75 unit price',
                metaRight: '\$11.8 total',
                qtyText: '2',
              ),
              const SizedBox(height: 16),
              const _OrderListItemWithQty(
                title: 'Golden Fields Cornmeal',
                metaLeft: '\$8.75 unit price',
                metaRight: '\$22.1 total',
                qtyText: '2',
              ),
              const SizedBox(height: 16),
              const _OrderListItemWithQty(
                title: 'Crystal Spring Mineral Water',
                metaLeft: '\$8.75 unit price',
                metaRight: '\$16.7 total',
                qtyText: '2',
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// ---------------------------------------------------------------------------
/// HEADER CHROME: dark status bar strip + teal header bar
/// ---------------------------------------------------------------------------

class _HeaderChrome extends StatelessWidget {
  final String txnIdText;
  const _HeaderChrome({required this.txnIdText});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        color: _Palette.bgHeaderBar,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 14,
              height: 20,
              child: InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: _Palette.textOnHeader,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                txnIdText,
                style: _TextStyles.headerTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CARD: Transaction details (white card w/ 16px radius? -> actually 8px)
/// rows separated by 1px divider #E9E9E9
/// left label 16/600 #212121
/// right value 14/400 #4D4D4D
/// "Transfer date" row has "25 Dec 2024 • 6:30pm"
/// ---------------------------------------------------------------------------

class _TransactionDetailsCard extends StatelessWidget {
  final ProfilePaymentTransaction tx;
  const _TransactionDetailsCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _TxnRow(
        label: 'Card number',
        rightChild: Text(
          // <-- Dynamic data
          'Payment method: #${tx.userPaymentMethodId}',
          style: _TextStyles.detailsValue,
        ),
      ),
      _TxnRow(
        label: 'Transfer number',
        rightChild: Text(
          tx.transactionId ?? 'N/A', // <-- Dynamic data
          style: _TextStyles.detailsValue,
        ),
      ),
      _TxnRow(
        label: 'Transfer date',
        rightChild: Text(
          tx.formattedDateTime, // <-- Use model helper
          style: _TextStyles.detailsValue,
        ),
      ),
      _TxnRow(
        label: 'Recipient',
        rightChild: Text(
          'Order #${tx.orderId}', // <-- Dynamic data
          style: _TextStyles.detailsValue,
        ),
      ),
      _TxnRow(
        label: 'Amount',
        rightChild: Text(
          '\$${tx.amount}', // <-- Dynamic data
          style: _TextStyles.detailsValue,
        ),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _Palette.bgCard,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1)
              Container(
                margin: const EdgeInsets.only(top: 16),
                height: 1,
                color: _Palette.rowDivider,
              ),
            if (i != rows.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _TxnRow extends StatelessWidget {
  final String label;
  final Widget rightChild;
  const _TxnRow({
    required this.label,
    required this.rightChild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // left label
        Text(label, style: _TextStyles.detailsLabel),
        // right value
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: DefaultTextStyle(
              style: _TextStyles.detailsValue,
              child: rightChild,
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// ORDER LIST SECTION
/// Two row types:
/// 1. _OrderListItemPriceOnly  -> right side shows vertical divider + price/qty
/// 2. _OrderListItemWithQty    -> right side shows - 2 + pill group
///
/// Shared left side:
///  - leading 48x48 rounded 4 bg #F4F6F6, padding 11
///  - title 16/600 #212121
///  - meta row grey 14 w bullet
/// card padding: horizontal 16, vertical 12
/// card radius: 8
/// gap between cards: 16
/// ---------------------------------------------------------------------------

class _OrderListItemPriceOnly extends StatelessWidget {
  final String title;
  final String metaLeft;
  final String metaRight;
  final String amountText;
  final String itemsText;

  const _OrderListItemPriceOnly({
    required this.title,
    required this.metaLeft,
    required this.metaRight,
    required this.amountText,
    required this.itemsText,
  });

  @override
  Widget build(BuildContext context) {
    return _OrderCardShell(
      left: _OrderItemInfo(
        title: title,
        metaLeft: metaLeft,
        metaRight: metaRight,
      ),
      right: _RightPriceBlock(
        amountText: amountText,
        itemsText: itemsText,
      ),
    );
  }
}

class _OrderListItemWithQty extends StatelessWidget {
  final String title;
  final String metaLeft;
  final String metaRight;
  final String qtyText; // the number in the middle ("2", "5")

  const _OrderListItemWithQty({
    required this.title,
    required this.metaLeft,
    required this.metaRight,
    required this.qtyText,
  });

  @override
  Widget build(BuildContext context) {
    return _OrderCardShell(
      left: _OrderItemInfo(
        title: title,
        metaLeft: metaLeft,
        metaRight: metaRight,
      ),
      right: _RightQtyBlock(qtyText: qtyText),
      // NOTE: in the mock, these "with qty" rows *do not* show
      // that thin vertical divider line. We'll follow that.
      showDivider: false,
    );
  }
}

/// Base card layout shared by the two variants.
class _OrderCardShell extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool showDivider;

  const _OrderCardShell({
    required this.left,
    required this.right,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 382 in mock, but we already padded page 24px
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _Palette.bgCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading icon square (48x48)
          _LeadingThumb(),

          const SizedBox(width: 16),

          // Middle expanded text block
          Expanded(child: left),

          // Right side
          if (showDivider) ...[
            const SizedBox(width: 12),
            _VerticalDivider40(),
            const SizedBox(width: 12),
          ] else
            const SizedBox(width: 12),

          right,
        ],
      ),
    );
  }
}

// 48x48 light gray rounded box from the design. Placeholder content right now.
class _LeadingThumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _Palette.bgChip,
        borderRadius: BorderRadius.circular(4),
      ),
      // You can drop in actual Image.asset or SVG here.
      child: const SizedBox.expand(), // placeholder
    );
  }
}

// Middle column with title + meta row
class _OrderItemInfo extends StatelessWidget {
  final String title;
  final String metaLeft;
  final String metaRight;

  const _OrderItemInfo({
    required this.title,
    required this.metaLeft,
    required this.metaRight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: _TextStyles.itemTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                metaLeft,
                style: _TextStyles.itemMeta,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: _Palette.textBullet,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                metaRight,
                style: _TextStyles.itemMeta,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Thin vertical divider ~39px tall, 1px wide, color #DEE0E0 rotated etc.
class _VerticalDivider40 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 39,
      color: _Palette.vDivider,
    );
  }
}

// Right side "price block": $28.75 / 3 Item plus subtle shadow glow
class _RightPriceBlock extends StatelessWidget {
  final String amountText;
  final String itemsText;
  const _RightPriceBlock({
    required this.amountText,
    required this.itemsText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // In Figma it's basically just the text column with a soft drop shadow.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        boxShadow: const [
          BoxShadow(
            color: _Palette.priceShadow,
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(amountText, style: _TextStyles.itemAmt, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(itemsText, style: _TextStyles.itemQtyLine, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// Right side Quantity control block: [-]  qty  [+]
class _RightQtyBlock extends StatelessWidget {
  final String qtyText;
  const _RightQtyBlock({required this.qtyText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyStepButton(
          icon: Icons.remove,
          onTap: () {
            // hook up later
          },
        ),
        const SizedBox(width: 8),
        Container(
          decoration: const BoxDecoration(
            // just shadow around text number, no pill bg in mock
            boxShadow: [
              BoxShadow(
                color: _Palette.priceShadow,
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
            ],
          ),
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: 24,
            child: Text(
              qtyText,
              textAlign: TextAlign.center,
              style: _TextStyles.qtyNumber,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _QtyStepButton(
          icon: Icons.add,
          onTap: () {
            // hook up later
          },
        ),
      ],
    );
  }
}

// The +/- rounded pill (20x20 visual in Figma, border #33595B, bg #E6EAEB)
class _QtyStepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyStepButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: _Palette.qtyPillBg,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(width: 1, color: _Palette.qtyPillBorder),
          boxShadow: const [
            BoxShadow(
              color: _Palette.priceShadow,
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 14,
          color: _Palette.bgHeaderBar,
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// BOTTOM NAV BAR
/// White background, shadow upwards: rgba(51,89,91,0.16) blur 12 offset (0,-4)
/// 5 slots (4 Expanded icons + 1 selected "Profile")
/// We're mocking icons with empty boxes. Replace with actual SVGs/icons.
/// ---------------------------------------------------------------------------

