import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ui/theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  // 🔌 API stub – replace with live location/ETA later
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
    return Scaffold(
      backgroundColor: Colors.grey.shade200, // hidden by map background
      body: Stack(
        children: [
          // Map background (use an asset mock, or gray if missing)
          Positioned.fill(
            child: Image.asset(
              'assets/images/maps.png', // optional
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.srcOver,
              color: Colors.black.withOpacity(0.02),
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFEDEFF2)),
            ),
          ),

          // Top bar
          Positioned(
            left: 0, right: 0, top: 0,
            child: Container(
              color: AppColors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 72,
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: const [
                    BackButton(color: Colors.white),
                    SizedBox(width: 4),
                    Text('Order tracking',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),

          // Simple mock route (polyline + pins)
          Positioned.fill(
            child: CustomPaint(painter: _RoutePainter()),
          ),

          // Bottom sheet area (fixed, like your mock)
          _TrackingBottomCard(),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // rough path similar to mock
    final p = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * .18, size.height * .33)
      ..lineTo(size.width * .55, size.height * .38)
      ..lineTo(size.width * .55, size.height * .65)
      ..lineTo(size.width * .83, size.height * .74);

    canvas.drawPath(path, p);

    // start pin
    final start = Offset(size.width * .18, size.height * .33);
    final end = Offset(size.width * .83, size.height * .74);

    final pinStart = Paint()..color = AppColors.teal.withOpacity(.15);
    canvas.drawCircle(start, 14, pinStart);
    canvas.drawCircle(start, 6, Paint()..color = AppColors.teal);

    // end pin
    final pinEnd = Paint()..color = const Color(0xFFE56B4A);
    final pinEndHalo = Paint()..color = const Color(0xFFE56B4A).withOpacity(.18);
    canvas.drawCircle(end, 16, pinEndHalo);
    canvas.drawCircle(end, 8, pinEnd);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrackingBottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 72, height: 6,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Expanded(
                    child: Text('Your order is on the way',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  TextButton(
                    onPressed: Get.back,
                    child: const Text('Skip', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                children: const [
                  Expanded(
                    child: Text('Approximate time of delivery',
                        style: TextStyle(color: AppColors.subtext)),
                  ),
                  Text('4:30 PM', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 8),

              // timeline
              const _TimelineItem(
                dotFilled: true,
                title: 'Ordered',
                subtitle: '12:30, 7 Feb 2024',
              ),
              const _TimelineItem(
                dotFilled: true,
                title: 'Packed',
                subtitle: '3:10, 7 Feb 2024',
              ),
              const _TimelineItem(
                dotFilled: false,
                title: 'Delivered',
                subtitle: 'Not delivered yet',
                dim: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.dotFilled,
    required this.title,
    required this.subtitle,
    this.dim = false,
  });

  final bool dotFilled;
  final String title;
  final String subtitle;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final dotColor = dotFilled ? AppColors.teal : AppColors.divider;
    final tColor = dim ? AppColors.subtext : AppColors.text;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // dot + connector
          Column(
            children: [
              Container(
                width: 18, height: 18,
                decoration: BoxDecoration(
                  color: dotFilled ? AppColors.teal : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
              ),
              Container(
                width: 2, height: 26,
                color: AppColors.divider,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: tColor, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: AppColors.subtext)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
