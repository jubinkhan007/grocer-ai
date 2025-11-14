// lib/features/home/models/banner_model.dart
class PaginatedBannerList {
  final int count;
  final List<BannerModel> results;

  PaginatedBannerList({required this.count, required this.results});

  factory PaginatedBannerList.fromJson(Map<String, dynamic> json) {
    return PaginatedBannerList(
      count: json['count'] ?? 0,
      results: (json['results'] as List? ?? [])
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BannerModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? image; // URL
  final String? externalUrl;
  final String? appRoute;
  final String? type;

  BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.image,
    this.externalUrl,
    this.appRoute,
    this.type,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      image: json['image'],
      externalUrl: json['external_url'],
      appRoute: json['app_route'],
      type: json['type'],
    );
  }
}