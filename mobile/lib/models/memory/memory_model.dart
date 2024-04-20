import 'package:picmory/models/hashtag/hashtag_create_model.dart';

class MemoryModel {
  int id;
  DateTime createdAt;
  String? brand;
  String photoUri;
  String? videoUri;
  DateTime date;
  List<HashtagModel> hashtag;
  bool isLiked;

  MemoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = DateTime.parse(json['created_at']),
        brand = json['brand'],
        photoUri = json['photo_uri'],
        videoUri = json['video_uri'],
        date = DateTime.parse(json['date']),
        hashtag = json['hashtag'].map<HashtagModel>((e) => HashtagModel.fromJson(e)).toList(),
        isLiked = json['is_liked'] ?? false;
}
