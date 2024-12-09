import 'package:picmory/main.dart';

class MemoryFileModel {
  final String type;
  final String originalName;
  final int size;
  final String uri;
  final String thumbnailUri;

  MemoryFileModel.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        originalName = json['originalName'],
        size = json['size'],
        uri = '${remoteConfig.getString('storage_host')}/${json['path']}',
        thumbnailUri = '${remoteConfig.getString('storage_host')}/${json['thumbnailPath']}';
}
