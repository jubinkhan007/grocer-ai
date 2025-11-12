// lib/features/profile/views/partner_sheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/partner_controller.dart';
import '../models/partner_search_user.dart';

class PartnerSheet extends StatefulWidget {
  const PartnerSheet({super.key});

  @override
  State<PartnerSheet> createState() => _PartnerSheetState();
}

class _PartnerSheetState extends State<PartnerSheet> {
  // Figma tokens
  static const _sheetBg = Color(0xFFF4F6F6);
  static const _textPrimary = Color(0xFF212121);
  static const _teal = Color(0xFF33595B);
  static const _divider = Color(0xFFE0E0E0);
  static const _grabberGrey = Color(0xFFCBC4C4);
  static const _danger = Color(0xFFDA5A2A);

  final _newPartnerCtrl = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _newPartnerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartnerController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShell(
          context,
          child: const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      final partners = controller.partners;

      return _buildShell(
        context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== grabber =====
            Center(
              child: Container(
                width: 72,
                height: 6,
                decoration: BoxDecoration(
                  color: _grabberGrey,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ===== header (Partner / Edit partner + Edit/Save) =====
            Row(
              children: [
                Expanded(
                  child: Text(
                    _isEditing ? 'Edit partner' : 'Partner',
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!_isEditing) {
                      // enter edit mode
                      setState(() => _isEditing = true);
                    } else {
                      // Save (finish edit mode): clear inline field & suggestions
                      _newPartnerCtrl.clear();
                      controller.clearSearch();
                      if (mounted) {
                        setState(() => _isEditing = false);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text(
                      _isEditing ? 'Save' : 'Edit',
                      style: const TextStyle(
                        color: _teal,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Container(height: 1, color: _divider),
            const SizedBox(height: 24),

            // ===== partner pills =====
            ...partners.map(
                  (p) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PartnerTile(
                  name: p.name,
                  onRemove: () => controller.removePartner(p.id),
                ),
              ),
            ),

            // ===== footer: view vs edit mode =====
            if (!_isEditing) ...[
              const SizedBox(height: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() => _isEditing = true);
                },
                child: Row(
                  children: const [
                    Icon(Icons.add, color: _teal, size: 26),
                    SizedBox(width: 8),
                    Text(
                      'Add new partner',
                      style: TextStyle(
                        color: _teal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              _AddPartnerField(
                controller: _newPartnerCtrl,
                isSearching: controller.isSearching.value,
                suggestions: controller.searchResults,
                onChanged: controller.searchUsers,
                onSelectUser: (PartnerSearchUser user) async {
                  final ok = await controller.addPartnerFromUser(user);
                  if (ok) {
                    _newPartnerCtrl.clear();
                    controller.clearSearch();
                  } else {
                    Get.snackbar(
                      'Unable to add partner',
                      'Please try again.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                onPickFromContacts: () {
                  // hook contacts picker here when available
                },
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildShell(BuildContext context, {required Widget child}) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: _sheetBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 8,
          bottom: 24 + MediaQuery.of(context).padding.bottom,
        ),
        child: child,
      ),
    );
  }
}

/// ===== Single partner pill row (matches Figma) =====
class _PartnerTile extends StatelessWidget {
  const _PartnerTile({
    required this.name,
    required this.onRemove,
  });

  final String name;
  final VoidCallback onRemove;

  static const _teal = Color(0xFF33595B);
  static const _danger = Color(0xFFDA5A2A);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: _teal, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF212121),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onRemove,
            child: const Icon(Icons.close, color: _danger, size: 24),
          ),
        ],
      ),
    );
  }
}

/// ===== Bottom inline add field + search suggestions (edit mode) =====
class _AddPartnerField extends StatelessWidget {
  const _AddPartnerField({
    required this.controller,
    required this.isSearching,
    required this.suggestions,
    required this.onChanged,
    required this.onSelectUser,
    required this.onPickFromContacts,
  });

  final TextEditingController controller;
  final bool isSearching;
  final List<PartnerSearchUser> suggestions;
  final ValueChanged<String> onChanged;
  final Future<void> Function(PartnerSearchUser user) onSelectUser;
  final VoidCallback onPickFromContacts;

  static const _teal = Color(0xFF33595B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // rounded pill TextField
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF212121),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9AA4A6),
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: _teal,
                    size: 24,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: const BorderSide(color: _teal, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // contact picker button (square teal, icon white)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPickFromContacts,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _teal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.contact_page_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        // search state + suggestions list
        if (isSearching)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 260, // ~5–6 rows; tweak to match Figma
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final user = suggestions[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onSelectUser(user),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: _teal,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.name.isNotEmpty ? user.name : user.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
