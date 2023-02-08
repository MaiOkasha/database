class Note {

  late int id;
  late String title;
  late String details;
  late int userId;

  Note();

  Note.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap['id'];
    title = rowMap['title'];
    details = rowMap['details'];
    userId = rowMap['user_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['title'] = title;
    map['details'] = details;
    map['user_id'] = userId;
    return map;
  }
}