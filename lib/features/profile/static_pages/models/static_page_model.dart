// lib/features/profile/static_pages/models/static_page_model.dart
class StaticPage {
  final String title;
  final String content;

  StaticPage({required this.title, required this.content});

  factory StaticPage.fromJson(Map<String, dynamic> json) {
    return StaticPage(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}