import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  NotificationController(this._service);
  final NotificationService _service;

  final notifications = <AppNotification>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      notifications.assignAll(await _service.fetchNotifications());
    } finally {
      isLoading.value = false;
    }
  }
}
