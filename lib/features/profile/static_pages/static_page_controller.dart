// lib/features/profile/static_pages/static_page_controller.dart
import 'package:get/get.dart';
import 'models/static_page_model.dart';
import 'static_page_service.dart';

class StaticPageController extends GetxController {
  final StaticPageService _service;
  final String pageType;

  StaticPageController(this._service, {required this.pageType});

  final page = Rxn<StaticPage>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPage();
  }

  Future<void> loadPage() async {
    try {
      isLoading.value = true;
      page.value = await _service.fetchPage(pageType);
    } catch (e) {
      Get.snackbar('Error', 'Could not load page content: $e');
      page.value = StaticPage(title: 'Error', content: 'Could not load content.');
    } finally {
      isLoading.value = false;
    }
  }
}