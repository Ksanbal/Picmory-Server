class CrawledQrModel {
  String brand;
  String photo;
  String video;

  CrawledQrModel.fromJson(Map<String, dynamic> json)
      : brand = json['brand'],
        photo = json['photo'],
        video = json['video'];
}
