class AlbumModel {
  int id;
  String name;
  List<String> imageUrls;

  AlbumModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageUrls = json['memory_album'].map<String>((e) {
          final uploads = e['memory']['upload'] as List<dynamic>;
          final photoUri = uploads.lastWhere((element) => element['is_photo'] == true);
          return photoUri['uri'] as String;
        }).toList();
}
