class BrandModel {
  String name;

  BrandModel.fromJson(Map<String, dynamic> json) : name = json['name'];
}
