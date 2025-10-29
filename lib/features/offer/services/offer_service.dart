// lib/features/offer/services/offer_service.dart

import 'package:dio/dio.dart';
import '../data/provider_model.dart';
import '../data/product_model.dart';

// Helper class to combine Provider and its Products
class ProviderWithProducts {
  final Provider provider;
  final List<Product> products;

  ProviderWithProducts({required this.provider, required this.products});
}

class OfferService {
  final Dio _dio;
  // Base URL from your endpoints
  final String _baseUrl = "http://45.88.223.47:8000/api/v1";

  OfferService(this._dio);

  /// Fetches all providers, then fetches products for each provider.
  Future<List<ProviderWithProducts>> getOffers() async {
    try {
      // 1. Fetch all providers
      final providerResponse = await _dio.get('$_baseUrl/providers/');
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
      final productResponse = await _dio.get('$_baseUrl/providers/${provider.id}/products/');
      final productList = ProductListResponse.fromJson(productResponse.data).results;

      return ProviderWithProducts(provider: provider, products: productList);
    } catch (e) {
      print("Error fetching products for provider ${provider.id}: $e");
      // Return provider with empty product list on error
      return ProviderWithProducts(provider: provider, products: []);
    }
  }
}