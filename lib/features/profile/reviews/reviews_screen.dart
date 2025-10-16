import 'package:flutter/material.dart';

import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/ff_app_bar.dart';
import '../../../ui/widgets/section_card.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FFAppBar(title: 'Reviews & Rating'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Overall rating'),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.star, color: AppColors.warning),
                    Icon(Icons.star, color: AppColors.warning),
                    Icon(Icons.star, color: AppColors.warning),
                    Icon(Icons.star, color: AppColors.warning),
                    Icon(Icons.star_half, color: AppColors.warning),
                    SizedBox(width: 8),
                    Text('4.5'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(6, (i) {
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSpacings.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Jane Cooper', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 6),
                  Text('Great experience, quick delivery.'),
                ],
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Write a review'),
        icon: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
