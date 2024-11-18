class CrawlModel {
  String brand;
  List<String> photoUrls;
  List<String> videoUrls;

  CrawlModel.fromJson(Map<String, dynamic> json)
      : brand = json['brand'],
        photoUrls = (json['photoUrls'] as List).map((e) => e.toString()).toList(),
        videoUrls = (json['videoUrls'] as List).map((e) => e.toString()).toList();
}
