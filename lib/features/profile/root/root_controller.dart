import 'package:get/get.dart';

class RootController extends GetxController {
  final index = 0.obs;
  void setIndex(int i) => index.value = i;
}
