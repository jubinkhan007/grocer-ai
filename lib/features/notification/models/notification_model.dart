class AppNotification {
  final int id;
  final String title;
  final String message;
  final String source;
  final String createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.source,
    required this.createdAt,
    required this.isRead,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      source: json['source'] ?? '',
      createdAt: json['created_at'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }
}
