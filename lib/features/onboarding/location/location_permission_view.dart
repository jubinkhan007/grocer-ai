import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ai/features/onboarding/location/location_controller.dart';


LocationController _loc() =>
    Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController());
/// ---- Brand colors used across the mockups ----
const _bg = Color(0xFFF1F4F6);
const _teal = Color(0xFF0C3E3D);
const _text = Color(0xFF33363E);
const _sub = Color(0xFF6B737C);
const _divider = Color(0xFFE1E6EA);
const _dialogRadius = 28.0;     // card corner
const _imgRadius    = 18.0;     // image corner
const _hPad         = 18.0;     // left/right padding inside card
const _topPad       = 18.0;     // top padding
const _between1     = 18.0;     // space image -> first paragraph
const _between2     = 14.0;     // space para1 -> para2
const _dividerGap   = 6.0;

class LocationPermissionView extends StatelessWidget {
  const LocationPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = _loc();
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ---- Header arc + centered logo (same system you’ve used) ----
            Stack(
              children: [
                Container(height: 156, color: _bg),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(w, 170),
                        bottomRight: Radius.elliptical(w, 170),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Image.asset(
                        'assets/images/logo_grocerai.png',
                        width: 210,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ---- Title + subtitle exactly as the mock ----
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "What’s your location?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Your privacy is important to us, and we only use this "
                    "information to offer a better service. Thank you!",
                    style: TextStyle(fontSize: 18, color: _sub, height: 1.35),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action button (disabled look under dialogs on your mocks)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(44),
                      ),
                    ),
                    onPressed: c.loading.value
                        ? null
                        : () => _showAccuracyCollapsed(context),
                    child: c.loading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Allow access to location',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- Collapsed accuracy dialog (Image 1) ----------------
void _showAccuracyCollapsed(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'For a better experience, your device will\n'
                          'need to use Location Accuracy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _text,
                        height: 1.25,
                      ),
                    ),
                  ),
                  // ➜ EXPAND to the detailed dialog
                  IconButton(
                    icon: const Icon(Icons.expand_more, color: _teal),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      // open the expanded version
                      Future.microtask(() => _showAccuracyExpanded(context));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: _divider),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ➜ SHOW the “Turn on device location” card
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Future.microtask(() => _showTurnOnLocation(context));
                    },
                    child: const Text('No thanks',
                        style: TextStyle(
                            color: _teal, fontWeight: FontWeight.w700, fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      final c = Get.find<LocationController>();
                      c.requestAndSaveLocation();
                    },
                    child: const Text('Turn on',
                        style: TextStyle(
                            color: _teal, fontWeight: FontWeight.w700, fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// ---------------- Expanded accuracy dialog (Image 2) ----------------
void _showAccuracyExpanded(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'For a better experience, your device will\n'
                          'need to use Location Accuracy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _text,
                        height: 1.25,
                      ),
                    ),
                  ),
                  // ➜ COLLAPSE back to the short dialog
                  IconButton(
                    icon: const Icon(Icons.expand_less, color: _teal),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Future.microtask(() => _showAccuracyCollapsed(context));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),

              _bulletRow(Icons.place_outlined, 'Device location'),
              const SizedBox(height: 12),
              _bulletRow(
                Icons.my_location_outlined,
                'Location Accuracy, which provides more accurate location for '
                    'apps and services. To do this, Google periodically processes '
                    'information about device sensors and wireless signals from '
                    'your device to crowdsource wireless signal locations. These '
                    'are used without identifying you to improve location accuracy '
                    'and location-based services and to improve, provide and '
                    'maintain Google’s services.',
              ),

              const SizedBox(height: 10),
              const Divider(color: _divider),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ➜ SHOW the “Turn on device location” card
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Future.microtask(() => _showTurnOnLocation(context));
                    },
                    child: const Text('No thanks',
                        style: TextStyle(
                            color: _teal, fontWeight: FontWeight.w700, fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      final c = Get.find<LocationController>();
                      c.requestAndSaveLocation();
                    },
                    child: const Text('Turn on',
                        style: TextStyle(
                            color: _teal, fontWeight: FontWeight.w700, fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// --------------- “Turn on device location” card (Image 3) ---------------
void _showTurnOnLocation(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // set false if you don’t want it dismissible
    builder: (ctx) {
      // Clamp text scaling so typography doesn't drift from Figma
      final mq = MediaQuery.of(ctx);
      final media = mq.copyWith(textScaler: const TextScaler.linear(1.0));

      // Figma base is 375 → dialog content width = 375 - 48 = 327
      const figmaDialogWidth = 327.0;

      return MediaQuery(
        data: media,
        child: Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_dialogRadius),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: figmaDialogWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(_hPad, _topPad, _hPad, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Illustration (exported from Figma; keep its 16:12 look)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(_imgRadius),
                    child: AspectRatio(
                      aspectRatio: 16 / 12,
                      child: Image.asset(
                        'assets/images/pana.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: _between1),

                  // Paragraph 1
                  const Text(
                    'We require your precise location to seamlessly connect '
                        'you to nearby service providers.',
                    style: TextStyle(
                      fontSize: 18,          // Figma size
                      height: 1.35,          // Figma line-height
                      color: Color(0xFF33363E),
                      fontWeight: FontWeight.w400,
                      // fontFamily: 'Inter', // uncomment to force your Figma font
                    ),
                  ),

                  const SizedBox(height: _between2),

                  // Paragraph 2
                  const Text(
                    'Please turn on device location.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.25,
                      color: Color(0xFF33363E),
                      fontWeight: FontWeight.w400,
                      // fontFamily: 'Inter',
                    ),
                  ),

                  const SizedBox(height: _dividerGap),
                  const Divider(color: Color(0xFFE1E6EA), height: 1),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 12),
                        foregroundColor: Color(0xFF0C3E3D),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          // fontFamily: 'Inter',
                          letterSpacing: 0.1,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Get.find<LocationController>().requestAndSaveLocation();
                      },
                      child: const Text('Try again'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


Widget _bulletRow(IconData icon, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: _teal),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: _text, height: 1.35),
        ),
      ),
    ],
  );
}

