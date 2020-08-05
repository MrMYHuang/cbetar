import 'Work.dart';

class Bookmark {
  String uuid;
  Work work;
  String selectedText;
  String fileName;

  Bookmark({this.uuid, this.work, this.selectedText, this.fileName});

  static Bookmark fromJson(dynamic json) {
    if (json != null) {
      return Bookmark(uuid: json['uuid'], work: Work.fromJson(json['work']), selectedText: json['selectedText'], fileName: json['fileName']);
    } else {
      return Bookmark();
    }
  }

  dynamic toJson() => {'uuid': uuid, 'work': work, 'selectedText': selectedText, 'fileName': fileName};
}