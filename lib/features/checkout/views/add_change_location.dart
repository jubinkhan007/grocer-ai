import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/design_tokens.dart';

class SetNewLocationScreen extends StatefulWidget {
  const SetNewLocationScreen({super.key});

  @override
  State<SetNewLocationScreen> createState() => _SetNewLocationScreenState();
}

class _SetNewLocationScreenState extends State<SetNewLocationScreen> {
  final TextEditingController _controller =
  TextEditingController(text: 'Kansas City');

  bool _showSuggestions = false;

  // fake recent/suggestion list
  final List<String> _suggestions = const [
    'Kansas City',
    'Knoxville',
    'Kalamazoo',
    'Kentucky',
    'Killeen',
    'Kingston',
  ];

  @override
  void initState() {
    super.initState();

    // match iOS light-content status bar on dark teal strip
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: statusTeal,
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ));
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }

  void _handleClear() {
    setState(() {
      _controller.clear();
      _showSuggestions = false;
    });
  }

  void _handleTapSearchField() {
    setState(() {
      _showSuggestions = true;
    });
  }

  void _handleSelectSuggestion(String value) {
    setState(() {
      _controller.text = value;
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          /// ================= STATUS STRIP =================
          ///
          /// Solid #002C2E bar under the OS notch, just like other Grocer screens.
          Container(
            color: statusTeal,
            width: double.infinity,
            padding: EdgeInsets.zero,
            child: SafeArea(
              bottom: false,
              child: const SizedBox(height: 0),
            ),
          ),

          /// ================= APP BAR =================
          ///
          /// #33595B, 24px horizontal padding, 20px vertical padding.
          Container(
            width: double.infinity,
            color: headerTeal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: _handleBack,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Color(0xFFFEFEFE),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Set new location',
                    style: TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= PAGE BODY =================
          ///
          /// Scrollable content starts 24px below teal header in Figma:
          /// teal header bottom is y=111, first pill is y=135.
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ---------- Search pill ----------
                  _SearchPill(
                    controller: _controller,
                    onTap: _handleTapSearchField,
                    onClear: _handleClear,
                  ),

                  /// ---------- Dropdown suggestions (state 2 in Figma) ----------
                  if (_showSuggestions) ...[
                    const SizedBox(height: 16),
                    _SuggestionsDropdown(
                      items: _suggestions,
                      onSelect: _handleSelectSuggestion,
                    ),
                  ],

                  const SizedBox(height: 24),

                  /// ---------- Saved addresses card ----------
                  _SavedAddressesBlock(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= SEARCH PILL =================
/// Big rounded 128 pill, white bg, 16px all-around padding,
/// left bubble 32x32 w/gray bg, teal-ish pin glyph,
/// text 18 / 500 / #212121,
/// trailing “X” clear icon 20x20.
class _SearchPill extends StatelessWidget {
  const _SearchPill({
    required this.controller,
    required this.onTap,
    required this.onClear,
  });

  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: pillBg,
      borderRadius: BorderRadius.circular(128),
      child: InkWell(
        borderRadius: BorderRadius.circular(128),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // leading 32x32 bubble
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bubbleBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: headerTeal,
                ),
              ),
              const SizedBox(width: 12),

              // text (acts like TextField visual, but read-only tap opens dropdown)
              Expanded(
                child: Text(
                  controller.text.isEmpty
                      ? 'Search city'
                      : controller.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // trailing X button
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onClear,
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= SUGGESTIONS DROPDOWN =================
/// White card w/ radius 8, subtle shadow (0,4,4,rgba(0,0,0,0.1)),
/// each row: 16 vertical + 24 horizontal, label 14/400 #4D4D4D.
class _SuggestionsDropdown extends StatelessWidget {
  const _SuggestionsDropdown({
    required this.items,
    required this.onSelect,
  });

  final List<String> items;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: sheetShadow,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            InkWell(
              onTap: () => onSelect(items[i]),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    items[i],
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
            if (i != items.length - 1)
              const Divider(height: 1, thickness: 0.0, color: Colors.transparent),
          ],
        ],
      ),
    );
  }
}

/// ================= SAVED ADDRESSES CARD =================
/// This block is literally the white sheet in Figma with:
///   - Work row
///   - divider
///   - Home row
/// Padding: 8 around rows
/// Each row: leading 32x32 rounded bubble (#E6EAEB)
/// Title: 14 / 700 / #4D4D4D
/// Subtitle: 16 / 400 / #4D4D4D
class _SavedAddressesBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // On Figma, the lower half is white full-bleed,
      // but visually each row has 8px inner padding.
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(0), // block is flush white, no card radius
        boxShadow: const [], // no card shadow here
      ),
      child: Column(
        children: [
          _SavedAddressRow(
            bubbleIcon: Icons.work_outline,
            title: 'Work',
            subtitle: 'Kansas city',
            showTopDivider: false,
          ),
          _SavedAddressRow(
            bubbleIcon: Icons.home_outlined,
            title: 'Home',
            subtitle: 'Set home address',
            showTopDivider: true,
          ),
        ],
      ),
    );
  }
}

class _SavedAddressRow extends StatelessWidget {
  const _SavedAddressRow({
    required this.bubbleIcon,
    required this.title,
    required this.subtitle,
    required this.showTopDivider,
  });

  final IconData bubbleIcon;
  final String title;
  final String subtitle;
  final bool showTopDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTopDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: dividerGrey,
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 32x32 rounded bubble w/ teal-ish icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bubbleBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  bubbleIcon,
                  size: 18,
                  color: headerTeal,
                ),
              ),
              const SizedBox(width: 12),

              // Texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}