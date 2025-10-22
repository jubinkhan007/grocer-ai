// lib/features/products/controllers/products_controller.dart
import 'package:get/get.dart';
import '../data/products_repository.dart';
import '../models/product.dart';
import '../../../core/theme/network/error_mapper.dart';

class ProductsController extends GetxController {
  final ProductsRepository repo;
  ProductsController(this.repo);

  final products = <Product>[].obs;
  final loading = false.obs;
  final search = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      products.assignAll(await repo.fetch(search: search.value));
    } on ApiFailure catch (e) {
      Get.snackbar('Products', e.message);
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateSearch(String q) async {
    search.value = q;
    await load();
  }
}
