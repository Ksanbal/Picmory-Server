import 'package:picmory/models/hashtag/hashtag_create_model.dart';

class MemoryListModel {
  int id;
  String photoUri;
  DateTime date;
  List<HashtagModel> hashtag;

  MemoryListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        photoUri = json['photo_uri'],
        date = DateTime.parse(json['date']),
        hashtag = json['hashtag'].map<HashtagModel>((e) => HashtagModel.fromJson(e)).toList();
}
