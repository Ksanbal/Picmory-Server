class CrawledQrModel {
  String brand;
  List<String> photo;
  List<String> video;

  CrawledQrModel.fromJson(Map<String, dynamic> json)
      : brand = json['brand'],
        photo = json['photo'].map<String>((e) => e.toString()).toList(),
        video = json['video'].map<String>((e) => e.toString()).toList();
}
