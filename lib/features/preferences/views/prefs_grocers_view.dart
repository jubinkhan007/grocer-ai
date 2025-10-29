import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocer_ai/features/preferences/views/prefs_household_view.dart';

import '../widgets/next_button.dart';

class NearbyGrocersScreen extends StatefulWidget {
  const NearbyGrocersScreen({super.key});

  @override
  State<NearbyGrocersScreen> createState() => _NearbyGrocersScreenState();
}

class _NearbyGrocersScreenState extends State<NearbyGrocersScreen> {
  /// ===== FIGMA TOKENS =====
  static const _pageBg = Color(0xFFF4F6F6);
  static const _statusTeal = Color(0xFF002C2E); // strip behind iOS status bar
  static const _teal = Color(0xFF33595B); // border, active fill, CTA bg
  static const _textPrimary = Color(0xFF212121);
  static const _textSecondary = Color(0xFF4D4D4D);
  static const _stepInactive = Color(0xFFBABABA);

  // Fake data for grocers. Swap logo with your real asset widgets.
  final List<_StoreOption> _stores = [
    _StoreOption(
      id: 'walmart',
      label: 'Walmart',
      logo: Image.asset('assets/images/walmart.png'),
    ),
    _StoreOption(
      id: 'kroger',
      label: 'Kroger',
      logo: Image.asset('assets/images/kroger.png'),
    ),
    _StoreOption(
      id: 'aldi',
      label: 'Aldi',
      logo: Image.asset('assets/images/aldi.png'),
    ),
    _StoreOption(
      id: 'fred',
      label: 'Fred Myers',
      logo: Image.asset('assets/images/fred_meyer.png'),
    ),
    _StoreOption(
      id: 'united',
      label: 'United Supermarkets',
      logo: Image.asset('assets/images/united_supermarket.png'),
    ),
  ];

  /// Track selected store IDs, max 3.
  final Set<String> _selected = {};

  void _toggleStore(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        if (_selected.length < 3) {
          _selected.add(id);
        }
      }
    });
  }

  void _onCtaPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const HouseholdScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Light status icons over dark teal bar.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS (light content)
    ));

    final media = MediaQuery.of(context);
    final bottomSafe = media.padding.bottom;

    final bool hasSelection = _selected.isNotEmpty;

    return Scaffold(
      backgroundColor: _pageBg,
      body: Stack(
        children: [
          /// ===== MAIN COLUMN (status bar strip + steps + scroll body) =====
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// ===== STATUS STRIP (dark teal behind system status area) =====
              Container(
                color: _statusTeal,
                padding: EdgeInsets.only(
                  top: media.padding.top,
                  bottom: 8, // ~8px gap under status info in figma
                  left: 24,
                  right: 24,
                ),
                // We don't manually draw "9:41" because OS shows status chrome.
              ),

              /// ===== PROGRESS STEPS ROW (6 little rounded bars) =====
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Row(
                  children: const [
                    Expanded(child: _StepBar(color: _teal)),
                    SizedBox(width: 8),
                    Expanded(child: _StepBar(color: _stepInactive)),
                    SizedBox(width: 8),
                    Expanded(child: _StepBar(color: _stepInactive)),
                    SizedBox(width: 8),
                    Expanded(child: _StepBar(color: _stepInactive)),
                    SizedBox(width: 8),
                    Expanded(child: _StepBar(color: _stepInactive)),
                    SizedBox(width: 8),
                    Expanded(child: _StepBar(color: _stepInactive)),
                  ],
                ),
              ),

              /// ===== SCROLLABLE CONTENT (title + chips) =====
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    0,
                    24,
                    // give the scroll view bottom padding so last row
                    // never hides under the CTA when it shows
                    hasSelection ? (56 + 24 + bottomSafe) : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Title + subtitle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Nearby Grocers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 24,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '(Select upto 3)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),

                      /// Pills grid (explicit 2-col rows to match figma)
                      _TwoColRow(
                        leftChild: _StoreChip(
                          option: _stores[0],
                          selected: _selected.contains(_stores[0].id),
                          onTap: () => _toggleStore(_stores[0].id),
                        ),
                        rightChild: _StoreChip(
                          option: _stores[1],
                          selected: _selected.contains(_stores[1].id),
                          onTap: () => _toggleStore(_stores[1].id),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _TwoColRow(
                        leftChild: _StoreChip(
                          option: _stores[2],
                          selected: _selected.contains(_stores[2].id),
                          onTap: () => _toggleStore(_stores[2].id),
                        ),
                        rightChild: _StoreChip(
                          option: _stores[3],
                          selected: _selected.contains(_stores[3].id),
                          onTap: () => _toggleStore(_stores[3].id),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FullWidthRow(
                        child: _StoreChip(
                          option: _stores[4],
                          selected: _selected.contains(_stores[4].id),
                          onTap: () => _toggleStore(_stores[4].id),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// ===== BOTTOM CTA (only visible once user selected >=1 grocer) =====
          Positioned(
            left: 24,
            right: 24,
            bottom: 24 + bottomSafe,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: hasSelection
                  ? NextArrowButton(
                key: const ValueKey('cta-visible'),
                onNext: _onCtaPressed,
              )
                  : const SizedBox(
                key: ValueKey('cta-hidden'),
              ),

            ),
          ),
        ],
      ),
    );
  }
}

/// One of the step bars (progress indicators at top)
class _StepBar extends StatelessWidget {
  final Color color;
  const _StepBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

/// Data model for each grocer option
class _StoreOption {
  final String id;
  final String label;
  final Widget logo;
  const _StoreOption({
    required this.id,
    required this.label,
    required this.logo,
  });
}

/// Store chip pill:
/// - 48px tall
/// - radius 48
/// - stroke 1px #33595B
/// - selected: fill #33595B, text/logo turn white
class _StoreChip extends StatelessWidget {
  static const _teal = Color(0xFF33595B);
  static const _textPrimary = Color(0xFF212121);

  final _StoreOption option;
  final bool selected;
  final VoidCallback onTap;

  const _StoreChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? _teal : Colors.transparent;
    final labelColor = selected ? Colors.white : _textPrimary;

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48),
        side: const BorderSide(color: _teal, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(48),
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo: 24x24 in figma. When selected, logo appears white.
              SizedBox(
                width: 24,
                height: 24,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: selected
                      ? const Icon(
                    Icons.store,
                    size: 24,
                    color: Colors.white,
                  )
                      : option.logo,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                option.label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Row with 2 equal-width chips (16px gap)
class _TwoColRow extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  const _TwoColRow({
    required this.leftChild,
    required this.rightChild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: leftChild),
        const SizedBox(width: 16),
        Expanded(child: rightChild),
      ],
    );
  }
}

/// Row for a single full-width chip (United Supermarkets)
class _FullWidthRow extends StatelessWidget {
  final Widget child;
  const _FullWidthRow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
      ],
    );
  }
}

/// TEMP placeholder for logos so this code runs without assets.
/// Replace in production with Image.asset(...) or SvgPicture.asset(...).
class _FakeLogo extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String label;
  const _FakeLogo({
    required this.width,
    required this.height,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          height: 1.0,
        ),
      ),
    );
  }
}
