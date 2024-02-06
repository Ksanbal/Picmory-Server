class HashtagModel {
  String name;

  HashtagModel({
    required this.name,
  });

  toJson() {
    return {
      'name': name,
    };
  }

  HashtagModel.fromJson(Map<String, dynamic> json) : name = json['name'];
}
