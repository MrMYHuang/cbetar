import 'Work.dart';

enum BookmarkType {
  // Don't change the order! Otherwise, it breaks file compatibility!
  CATALOG,
  WORK,
  JUAN,
}

class Bookmark {
  BookmarkType type;
  String uuid;
  Work work;
  String selectedText;
  // Catalog name or juan filename.
  String fileName;

  Bookmark({this.type, this.uuid = '', this.work, this.selectedText = '', this.fileName = ''});

  static Bookmark fromJson(dynamic json) {
    if (json != null) {
      final typeFormJson = json['type'] != null ? BookmarkType.values[json['type']] : BookmarkType.JUAN;
      return Bookmark(type: typeFormJson, uuid: json['uuid'], work: Work.fromJson(json['work']), selectedText: json['selectedText'], fileName: json['fileName']);
    } else {
      return Bookmark();
    }
  }

  dynamic toJson() => {'type': type.index, 'uuid': uuid, 'work': work, 'selectedText': selectedText, 'fileName': fileName};
}