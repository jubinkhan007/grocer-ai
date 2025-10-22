// lib/shell/main_shell_controller.dart
import 'package:get/get.dart';

class MainShellController extends GetxController {
  final current = 0.obs;

  void goTo(int index) => current.value = index;
}
