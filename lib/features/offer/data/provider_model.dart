// lib/features/offer/data/provider_model.dart

class ProviderListResponse {
  final int count;
  final List<Provider> results;

  ProviderListResponse({required this.count, required this.results});

  factory ProviderListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Provider> resultsList = list.map((i) => Provider.fromJson(i)).toList();
    return ProviderListResponse(
      count: json['count'],
      results: resultsList,
    );
  }
}

class Provider {
  final int id;
  final String name;
  final String logo;

  Provider({required this.id, required this.name, required this.logo});

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}