// lib/media/models/uploaded_media.dart
class UploadedMedia {
  // If your API only returns {"file": "<url>"}, id stays null.
  final int? id;
  final String url;

  UploadedMedia({this.id, required this.url});

  factory UploadedMedia.fromJson(Map<String, dynamic> j) {
    return UploadedMedia(
      id: j['id'],               // may be null if backend doesn’t send it
      url: j['file'] ?? '',      // your API returns {"file": "string"}
    );
  }
}
