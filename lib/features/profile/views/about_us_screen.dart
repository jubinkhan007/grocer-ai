// lib/features/profile/views/about_us_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- IMPORT
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // <-- ADD THIS
import '../../../ui/theme/app_theme.dart';
import '../static_pages/static_page_controller.dart'; // <-- IMPORT

// --- MODIFIED: Converted to GetView<StaticPageController> ---
class AboutUsScreen extends GetView<StaticPageController> {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'), // Title is static
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
      ),
      // --- MODIFIED: Added Obx ---
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.page.value == null) {
          return const Center(child: Text('Could not load content.'));
        }
        // Use HtmlWidget to render HTML content from the API
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: HtmlWidget(
            controller.page.value!.content,
            textStyle: const TextStyle(
                fontSize: 15, height: 1.6, color: AppColors.text),
          ),
        );
      }),
    );
  }
}