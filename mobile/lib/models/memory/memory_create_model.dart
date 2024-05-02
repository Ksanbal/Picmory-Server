class MemoryCreateModel {
  String userId;
  String? photoUri;
  String? videoUri;
  DateTime date = DateTime.now();
  String? brand;

  MemoryCreateModel({
    required this.userId,
    this.photoUri,
    this.videoUri,
    required this.date,
    this.brand,
  });

  toJson() {
    return {
      'user_id': userId,
      'photo_uri': photoUri,
      'video_uri': videoUri,
      'date': date.toIso8601String(),
      'brand': brand,
    };
  }
}
