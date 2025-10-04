// lib/features/preferences/preferences_repository.dart
import 'package:dio/dio.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';
import 'package:grocer_ai/core/theme/network/error_mapper.dart';

class PreferencesRepository {
  final DioClient _client;
  PreferencesRepository(this._client);

  Future<PrefOptions> load() async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/api/v1/preferences/',
      );
      final data = res.data ?? {};
      return PrefOptions.fromJson(data);
    } on DioException catch (e) {
      // e.error is Object? -> make sure we throw a NON-null ApiFailure
      if (e.error is ApiFailure) {
        throw e.error as ApiFailure;
      }
      throw ApiFailure.fromDioError(e);
    }
  }

  Future<void> submit(PrefPayload payload) async {
    try {
      await _client.dio.post('/api/v1/preferences/', data: payload.toJson());
    } on DioException catch (e) {
      if (e.error is ApiFailure) {
        throw e.error as ApiFailure;
      }
      throw ApiFailure.fromDioError(e);
    }
  }
}

/// -------- Models (be liberal with field names to survive API changes)
class PrefOptions {
  final List<GroceryBrand> grocers; // logos + names
  final int grocerMax;
  final int defaultAdults;
  final int defaultKids;
  final int defaultPets;
  final List<String> diet;
  final List<String> cuisine;
  final List<String> frequency; // e.g. Daily/Weekly/Monthly
  final List<String> budgets; // e.g. "$ 50 - 80"

  PrefOptions({
    required this.grocers,
    required this.grocerMax,
    required this.defaultAdults,
    required this.defaultKids,
    required this.defaultPets,
    required this.diet,
    required this.cuisine,
    required this.frequency,
    required this.budgets,
  });

  factory PrefOptions.fromJson(Map<String, dynamic> json) {
    List<GroceryBrand> _grocers = [];
    final g = (json['grocers'] ?? json['nearby_grocers'] ?? []) as List;
    _grocers = g
        .map((e) => GroceryBrand.fromJson(e as Map<String, dynamic>))
        .toList();

    List<String> _stringList(dynamic v) =>
        (v as List?)?.map((e) => e.toString()).toList() ?? const [];

    return PrefOptions(
      grocers: _grocers,
      grocerMax: (json['grocer_max_selection'] ?? 3) as int,
      defaultAdults: (json['defaults']?['adults'] ?? 2) as int,
      defaultKids: (json['defaults']?['kids'] ?? 0) as int,
      defaultPets: (json['defaults']?['pets'] ?? 0) as int,
      diet: _stringList(json['diet'] ?? json['dietary']),
      cuisine: _stringList(json['cuisine']),
      frequency: _stringList(json['frequency']),
      budgets: _stringList(json['budgets'] ?? json['budget_ranges']),
    );
  }
}

class GroceryBrand {
  final String id;
  final String name;
  final String? logo; // absolute or asset-like
  GroceryBrand({required this.id, required this.name, this.logo});
  factory GroceryBrand.fromJson(Map<String, dynamic> j) => GroceryBrand(
    id: (j['id'] ?? j['slug'] ?? j['name']).toString(),
    name: (j['name'] ?? '').toString(),
    logo: j['logo']?.toString(),
  );
}

class PrefPayload {
  // Submit format, adapt to server expectations if needed
  final List<String> grocers;
  final int adults, kids, pets;
  final List<String> diet, cuisine;
  final String frequency;
  final String budget; // chip OR custom text
  final String? dietNote;
  final String? cuisineNote;

  PrefPayload({
    required this.grocers,
    required this.adults,
    required this.kids,
    required this.pets,
    required this.diet,
    required this.cuisine,
    required this.frequency,
    required this.budget,
    this.dietNote,
    this.cuisineNote,
  });

  Map<String, dynamic> toJson() => {
    'grocers': grocers,
    'household': {'adults': adults, 'kids': kids, 'pets': pets},
    'diet': {'selected': diet, 'note': dietNote},
    'cuisine': {'selected': cuisine, 'note': cuisineNote},
    'frequency': frequency,
    'budget': budget,
  };
}
