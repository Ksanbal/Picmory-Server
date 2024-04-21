class MemoryUploadModel {
  final String uri;
  final bool isPhoto;

  MemoryUploadModel.fromJson(Map<String, dynamic> json)
      : uri = json['uri'],
        isPhoto = json['is_photo'];
}
