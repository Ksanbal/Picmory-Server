class HashtagCreateModel {
  String name;

  HashtagCreateModel({
    required this.name,
  });

  toJson() {
    return {
      'name': name,
    };
  }
}
