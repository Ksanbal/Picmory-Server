class MemberModel {
  int id;
  DateTime createdAt;
  String providerId;
  String provider;
  String email;
  String name;
  bool isAdmin;

  MemberModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = DateTime.parse(json['createdAt']),
        providerId = json['providerId'],
        provider = json['provider'],
        email = json['email'],
        name = json['name'],
        isAdmin = json['isAdmin'];
}
