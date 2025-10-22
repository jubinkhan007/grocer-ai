// lib/shell/main_binding.dart
import 'package:get/get.dart';

import 'main_shell_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainShellController());
  }
}