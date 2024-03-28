class AlbumModel {
  int id;
  String name;
  List<String> imageUrls;

  AlbumModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageUrls = json['memory_album'].map<String>((e) {
          return e['memory']['photo_uri'] as String;
        }).toList();
}
