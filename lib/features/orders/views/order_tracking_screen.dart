import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Future<void> _loadTracking() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _loadTracking();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top; // iOS status-bar / notch
    // Figma: status bar 48 + header 69 ≈ 117 (visual)
    const double headerBodyHeight = 69;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Stack(
        children: [
          // --- MAP (mock) ----------------------------------------------------
          Positioned.fill(
            child: Image.asset(
              'assets/images/maps.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFEDEFF2)),
            ),
          ),

          // simple route painter to match the angles/weight from Figma
          Positioned.fill(child: CustomPaint(painter: _FigmaRoutePainter())),

          // dim overlay under the header (Figma adds a soft scrim)
          Positioned(
            left: 0,
            right: 0,
            top: topInset + headerBodyHeight +  -6, // tiny nudge so it starts just under header
            child: Container(
              height: 536, // from the plugin block
              color: Colors.black.withOpacity(0.08),
            ),
          ),

          // --- HEADER (pixel values from Figma plugin) -----------------------
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: const Color(0xFF33595B),
              padding: EdgeInsets.only(left: 0, right: 0, top: topInset, bottom: 20),
              height: topInset + headerBodyHeight,
              child: Row(
                children: [
                  // back chevron same feel as Figma (14x20 approx)
                  IconButton(
                    onPressed: Get.back,
                    padding: EdgeInsets.zero,
                    iconSize: 22,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 0),
                  const Text(
                    'Order tracking',
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 20,           // Figma: 20, w700
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BOTTOM SHEET (exact paddings/radius/typography) ---------------
          _TrackingBottomSheet(),
        ],
      ),
    );
  }
}

// ===== Map route / pins (visual approximation of Figma) ======================
class _FigmaRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Path
    final p = Paint()
      ..color = const Color(0xFF33595B)
      ..strokeWidth = 6               // heavier to match Figma look
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * .12, size.height * .36) // left start
      ..lineTo(size.width * .56, size.height * .42) // first segment
      ..lineTo(size.width * .53, size.height * .72) // vertical-ish segment
      ..lineTo(size.width * .80, size.height * .78); // final segment

    canvas.drawPath(path, p);

    // Start pin (three concentric circles like plugin)
    final start = Offset(size.width * .12, size.height * .36);
    canvas.drawCircle(start, 16, Paint()..color = const Color(0x333F57D9)); // outer halo
    canvas.drawCircle(start, 10.7, Paint()..color = const Color(0x4C3F57D9)); // mid
    canvas.drawCircle(start, 5.3, Paint()..color = const Color(0xFF3F57D9)); // dot

    // Destination pin (simple round with white center per plugin)
    final end = Offset(size.width * .80, size.height * .78);
    final pin = Paint()..color = const Color(0xFFE05A2A);
    final pinHalo = Paint()..color = const Color(0xFFE05A2A).withOpacity(.16);
    canvas.drawCircle(end, 20, pinHalo);
    canvas.drawCircle(end, 12, pin);
    canvas.drawCircle(end, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ===== Bottom sheet ==========================================================
class _TrackingBottomSheet extends StatelessWidget {
  const _TrackingBottomSheet();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 24 + bottomInset),
        decoration: const ShapeDecoration(
          color: Color(0xFFF4F6F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 64,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),

            // header row inside the card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Your order is on the way',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: const Color(0xFF33595B),
                        ),
                        onPressed: Get.back,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: const Color(0xFFE0E0E0)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ETA + timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Approximate time of delivery',
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        '4:30 PM',
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // timeline column – segment colors match plugin
                  const _TimelineRow(
                    title: 'Ordered',
                    subtitle: '12:30, 7 Feb 2024',
                    topLineColor: Colors.transparent,
                    bottomLineColor: Color(0xFF33595B),
                    dotStyle: _DotStyle.filledTeal,
                  ),
                  const SizedBox(height: 14),
                  const _TimelineRow(
                    title: 'Packed',
                    subtitle: '3:10, 7 Feb 2024',
                    topLineColor: Color(0xFF33595B),
                    bottomLineColor: Color(0xFFB0BFBF),
                    dotStyle: _DotStyle.filledTeal,
                  ),
                  const SizedBox(height: 14),
                  const _TimelineRow(
                    title: 'Delivered',
                    subtitle: 'Not delivered yet',
                    dim: true,
                    topLineColor: Color(0xFFB0BFBF),
                    bottomLineColor: Colors.transparent,
                    dotStyle: _DotStyle.hollowGray, // inner 16px like plugin
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

// ===== Timeline bits =========================================================
enum _DotStyle { filledTeal, hollowGray }

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.title,
    required this.subtitle,
    required this.topLineColor,
    required this.bottomLineColor,
    required this.dotStyle,
    this.dim = false,
  });

  final String title;
  final String subtitle;
  final Color topLineColor;
  final Color bottomLineColor;
  final _DotStyle dotStyle;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final titleColor = dim ? const Color(0xFF212121) : const Color(0xFF212121);
    final subColor = dim ? const Color(0xFF4D4D4D) : const Color(0xFF4D4D4D);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // left: dot + two line segments stacked
        SizedBox(
          width: 28,
          child: Column(
            children: [
              // top connector
              Container(width: 2, height: 10, color: topLineColor),
              // dot (20x20 area)
              Stack(
                alignment: Alignment.center,
                children: [
                  if (dotStyle == _DotStyle.filledTeal)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF33595B),
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                  // hollow gray look in plugin (inner 16 light gray)
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB0BFBF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              // bottom connector (70px in plugin, we use a compact 26 here and spacing above/below equals)
              Container(width: 2, height: 26, color: bottomLineColor),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // right labels
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                    color: subColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
