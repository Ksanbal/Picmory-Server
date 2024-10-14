class AlbumModel {
  int id;
  String name;
  int memoryCount;
  String coverImagePath;

  AlbumModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        memoryCount = json['memoryCount'],
        coverImagePath = json['coverImagePath'];
}
