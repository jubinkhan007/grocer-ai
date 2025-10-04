import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ---- Brand colors used across the mockups ----
const _bg = Color(0xFFF1F4F6);
const _teal = Color(0xFF0C3E3D);
const _text = Color(0xFF33363E);
const _sub = Color(0xFF6B737C);
const _divider = Color(0xFFE1E6EA);

class LocationPermissionView extends StatelessWidget {
  const LocationPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(44),
                    ),
                  ),
                  onPressed: () {
                    _showAccuracyCollapsed(context);
                  },
                  child: const Text(
                    'Allow access to location',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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

/// ---------------- Collapsed accuracy dialog (Image 1 & 4) ----------------
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
                  IconButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showAccuracyExpanded(context);
                    },
                    icon: const Icon(Icons.expand_more, color: _teal),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: _divider),

              // Buttons row (like your mock)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Navigator.of(ctx).pop,
                    child: const Text(
                      'No thanks',
                      style: TextStyle(
                        color: _teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showTurnOnLocation(context);
                    },
                    child: const Text(
                      'Turn on',
                      style: TextStyle(
                        color: _teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
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
                  IconButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showAccuracyCollapsed(context);
                    },
                    icon: const Icon(Icons.expand_less, color: _teal),
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
                  TextButton(
                    onPressed: Navigator.of(ctx).pop,
                    child: const Text(
                      'No thanks',
                      style: TextStyle(
                        color: _teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _showTurnOnLocation(context);
                    },
                    child: const Text(
                      'Turn on',
                      style: TextStyle(
                        color: _teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
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

/// --------------- “Turn on device location” card (Image 3) ---------------
void _showTurnOnLocation(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Illustration
              AspectRatio(
                aspectRatio: 16 / 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/images/illus_location_card.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'We require your precise location to seamlessly connect '
                  'you to nearby service providers.',
                  style: TextStyle(fontSize: 18, color: _text, height: 1.35),
                ),
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please turn on device location.',
                  style: TextStyle(fontSize: 18, color: _text),
                ),
              ),
              const SizedBox(height: 6),
              const Divider(color: _divider),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // After user turns on location, you could proceed to request permission.
                  },
                  child: const Text(
                    'Try again',
                    style: TextStyle(
                      color: _teal,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
