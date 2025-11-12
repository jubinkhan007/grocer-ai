// lib/features/offer/services/offer_service.dart

import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import '../data/provider_model.dart';
import '../data/product_model.dart';

// Helper class to combine Provider and its Products
class ProviderWithProducts {
  final Provider provider;
  final List<Product> products;

  ProviderWithProducts({required this.provider, required this.products});
}

class OfferService {
  // --- MODIFIED: Use DioClient ---
  final DioClient _dioClient;

  // --- MODIFIED: Use DioClient ---
  OfferService(this._dioClient);

  /// Fetches all providers, then fetches products for each provider.
  Future<List<ProviderWithProducts>> getOffers() async {
    try {
      // 1. Fetch all providers
      // --- MODIFIED: Use _dioClient and ApiPath ---
      final providerResponse = await _dioClient.getJson(ApiPath.providers);
      final providerList = ProviderListResponse.fromJson(providerResponse.data).results;

      // 2. Fetch products for each provider concurrently
      List<Future<ProviderWithProducts>> futures = [];

      for (var provider in providerList) {
        futures.add(_getProductsForProvider(provider));
      }

      // Wait for all product fetches to complete
      final combinedData = await Future.wait(futures);
      return combinedData;

    } catch (e) {
      // Handle or re-throw error
      print("Error fetching offers: $e");
      rethrow;
    }
  }

  /// Helper to fetch products for a single provider and combine them.
  Future<ProviderWithProducts> _getProductsForProvider(Provider provider) async {
    try {
      // --- MODIFIED: Use _dioClient and ApiPath ---
      // API spec shows /api/v1/providers/{id}/products/
      final productResponse = await _dioClient.getJson('${ApiPath.providers}${provider.id}/products/');
      final productList = ProductListResponse.fromJson(productResponse.data).results;

      return ProviderWithProducts(provider: provider, products: productList);
    } catch (e) {
      print("Error fetching products for provider ${provider.id}: $e");
      // Return provider with empty product list on error
      return ProviderWithProducts(provider: provider, products: []);
    }
  }
}