import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Brand colors to stay consistent with your login/signup screens.
const _topTeal = Color(0xFF0C3E3D);
const _pageBg = Color(0xFFF1F4F6);

/// Standardized error kinds for convenience constructors.
enum AppErrorKind { network, notFound, server, permission, unknown }

/// Reusable full-screen error page. Can also be used as an inline widget by
/// putting it inside a SizedBox if you want a compact state in lists, etc.
class AppErrorPage extends StatelessWidget {
  final String title;
  final String message;
  final String? errorCode; // optional: show “Code: 500”, etc
  final String? illustration; // asset path (png/svg/lottie converted to png)
  final String primaryLabel; // “Try Again”
  final VoidCallback? onPrimary; // retry
  final String? secondaryLabel; // “Go Home”
  final VoidCallback? onSecondary;

  /// Creates a custom error page.
  const AppErrorPage({
    super.key,
    required this.title,
    required this.message,
    this.errorCode,
    this.illustration,
    this.primaryLabel = 'Try Again',
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  /// Quick factories that pick copy + optional illustration by type.
  factory AppErrorPage.byKind(
    AppErrorKind kind, {
    Key? key,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    String? errorCode,
    String? illustration,
    String? secondaryLabel,
  }) {
    switch (kind) {
      case AppErrorKind.network:
        return AppErrorPage(
          key: key,
          title: 'No Internet',
          message: 'Check your connection and try again.',
          errorCode: errorCode,
          illustration: illustration ?? 'assets/images/',
          onPrimary: onPrimary,
          secondaryLabel: secondaryLabel ?? 'Go Home',
          onSecondary: onSecondary,
        );
      case AppErrorKind.notFound:
        return AppErrorPage(
          key: key,
          title: 'We can’t find that',
          message: 'The page or resource you’re looking for doesn’t exist.',
          errorCode: errorCode,
          illustration: illustration ?? 'assets/images/err_404.png',
          onPrimary: onPrimary,
          secondaryLabel: secondaryLabel ?? 'Go Back',
          onSecondary: onSecondary,
        );
      case AppErrorKind.server:
        return AppErrorPage(
          key: key,
          title: 'Something went wrong',
          message: 'Our servers seem busy. Please try again in a moment.',
          errorCode: errorCode,
          illustration: illustration ?? 'assets/images/err_server.png',
          onPrimary: onPrimary,
          secondaryLabel: secondaryLabel ?? 'Go Home',
          onSecondary: onSecondary,
        );
      case AppErrorKind.permission:
        return AppErrorPage(
          key: key,
          title: 'Permission needed',
          message:
              'We need your permission to continue. You can enable it in Settings.',
          errorCode: errorCode,
          illustration: illustration ?? 'assets/images/err_permission.png',
          onPrimary: onPrimary,
          secondaryLabel: secondaryLabel ?? 'Open Settings',
          onSecondary: onSecondary,
        );
      case AppErrorKind.unknown:
      default:
        return AppErrorPage(
          key: key,
          title: 'Oops!',
          message: 'An unexpected error occurred. Please try again.',
          errorCode: errorCode,
          illustration: illustration ?? 'assets/images/err_unknown.png',
          onPrimary: onPrimary,
          secondaryLabel: secondaryLabel ?? 'Go Home',
          onSecondary: onSecondary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header arc matches your auth screens
            Stack(
              children: [
                Container(height: 120, color: _pageBg),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(w, 140),
                        bottomRight: Radius.elliptical(w, 140),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Image.asset(
                          'assets/images/logo_grocerai.png',
                          width: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    if (illustration != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ErrorIllustration(asset: illustration!),
                      ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF33363E),
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6B737C),
                        height: 1.35,
                      ),
                    ),
                    if (errorCode != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Code: $errorCode',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF9AA4AE),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Primary “Try Again”
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: _topTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: onPrimary,
                        child: Text(
                          primaryLabel,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (secondaryLabel != null && onSecondary != null) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: onSecondary,
                        child: Text(
                          secondaryLabel!,
                          style: const TextStyle(
                            color: _topTeal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],

                    // In debug, show a mini stack hint if FlutterError.present
                    if (kDebugMode) ...[
                      const SizedBox(height: 12),
                      const _DebugHint(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Image block with graceful fallback (so missing asset doesn’t crash the page).
class _ErrorIllustration extends StatelessWidget {
  final String asset;
  const _ErrorIllustration({required this.asset});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Image.asset(
      asset,
      width: w * 0.72,
      height: w * 0.72,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.error_outline,
        size: w * 0.28,
        color: const Color(0xFFB7C2CA),
      ),
    );
  }
}

/// Shows a tiny debug hint in debug/profile builds; invisible in release.
class _DebugHint extends StatelessWidget {
  const _DebugHint();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Debug: check logs for stacktrace (FlutterError.onError).',
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: const Color(0xFFA3ADB8)),
    );
  }
}
