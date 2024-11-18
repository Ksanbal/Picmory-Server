class AccessTokenModel {
  final String accessToken;
  final String? refreshToken;

  AccessTokenModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}
