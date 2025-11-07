// lib/features/profile/static_pages/static_page_binding.dart
import 'package:get/get.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'static_page_controller.dart';
import 'static_page_service.dart';

class StaticPageBinding extends Bindings {
  final String pageType;
  StaticPageBinding({required this.pageType});

  @override
  void dependencies() {
    Get.lazyPut(() => StaticPageService(Get.find<DioClient>()), fenix: true);
    Get.lazyPut(
          () => StaticPageController(Get.find<StaticPageService>(),
          pageType: pageType),
    );
  }
}