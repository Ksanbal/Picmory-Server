class MemoryModel {
  int id;
  DateTime date;
  String brandName;
  bool like;
  List<MemoryFileModel> files;

  MemoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = DateTime.parse(json['date']),
        brandName = json['brandName'],
        like = json['like'],
        files = (json['files'] as List).map((file) => MemoryFileModel.fromJson(file)).toList();
}

class MemoryFileModel {
  String type;
  String originalName;
  int size;
  String path;
  String thumbnailPath;

  MemoryFileModel.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        originalName = json['originalName'],
        size = json['size'],
        path = json['path'],
        thumbnailPath = json['thumbnailPath'];
}
