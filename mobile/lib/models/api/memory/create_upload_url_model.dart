class CreateUploadUrlModel {
  String url;
  String key;

  CreateUploadUrlModel.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        key = json['key'];
}
