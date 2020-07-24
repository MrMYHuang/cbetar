import 'Work.dart';

class Bookmark {
  String uuid;
  Work work;
  String selectedText;

  Bookmark({this.uuid, this.work, this.selectedText});

  static Bookmark fromJson(dynamic json) {
    if (json != null) {
      return Bookmark(uuid: json['uuid'], work: Work.fromJson(json['work']), selectedText: json['selectedText']);
    } else {
      return Bookmark();
    }
  }

  dynamic toJson() => {'uuid': uuid, 'work': work, 'selectedText': selectedText};
}