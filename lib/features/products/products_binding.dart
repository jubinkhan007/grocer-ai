// lib/features/products/products_binding.dart
import 'package:get/get.dart';
import '../../core/theme/network/dio_client.dart';
import 'data/products_repository.dart';
import 'controllers/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductsRepository(Get.find<DioClient>()));
    Get.put(ProductsController(Get.find<ProductsRepository>()), permanent: true);
  }
}
