class MemoryListModel {
  int id;
  String photoUri;
  DateTime date;

  MemoryListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        photoUri = json['upload'].where((element) => element['is_photo'] == true).first['uri'],
        date = DateTime.parse(json['date']);

  @override
  String toString() {
    return {
      'id': id,
      'photoUri': photoUri,
      'date': date,
    }.toString();
  }
}
