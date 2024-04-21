import 'package:picmory/models/memory/memory_upload_model.dart';

class MemoryModel {
  int id;
  String? brand;
  DateTime date;
  bool isLiked;
  List<MemoryUploadModel> uploads;

  MemoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        brand = json['brand'],
        date = DateTime.parse(json['date']),
        isLiked = json['is_liked'] ?? false,
        uploads =
            json['upload'].map<MemoryUploadModel>((e) => MemoryUploadModel.fromJson(e)).toList();
}
