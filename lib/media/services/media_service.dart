// lib/features/media/services/media_service.dart
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grocer_ai/core/theme/network/api_endpoints.dart';
import 'package:grocer_ai/core/theme/network/dio_client.dart';

import '../models/uploaded_media.dart';

class MediaService {
  final DioClient _client;
  MediaService(this._client);

  Future<UploadedMedia> uploadOne(PlatformFile f) async {
    if (f.path == null) {
      throw Exception('Selected file has no path. Use withData or save to temp first.');
    }
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(f.path!, filename: f.name),
    });
    final res = await _client.postMultipart(ApiPath.mediaUpload, form);
    return UploadedMedia.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<UploadedMedia>> uploadMany(List<PlatformFile> files) async {
    final out = <UploadedMedia>[];
    for (final f in files) {
      if (f.path == null) continue;
      out.add(await uploadOne(f));
    }
    return out;
  }
}
