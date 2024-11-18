import 'package:picmory/models/memory/memory_file_model.dart';

class MemoryModel {
  int id;
  DateTime date;
  String brandName;
  bool like;
  List<MemoryFileModel> files;

  MemoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        brandName = json['brandName'],
        date = DateTime.parse(json['date']),
        like = json['like'],
        files = json['files'].map<MemoryFileModel>((e) => MemoryFileModel.fromJson(e)).toList();
}
