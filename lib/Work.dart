import 'package:cbetar/Utilities.dart';

class Work extends Model {
  String title;
  int juan;
  String juan_list;
  String work;

  Work({this.title, this.juan, this.juan_list = '', this.work}) : super(null);

  Work copyWith({Work workOrig}) =>
      Work(title: workOrig.title, juan: workOrig.juan, work: workOrig.work);

  @override
  Work.fromMap(Map<String, dynamic> json) : super(null) {
    this.title = json["title"];
    this.juan = json["juan"];
    this.juan_list = json["juan_list"];
    this.work = json["work"];
  }

  static Work fromJson(dynamic json) {
    if (json != null) {
      return Work(title: json["title"], juan: json["juan"], juan_list: json["juan_list"], work: json["work"],);
    } else {
      return Work();
    }
  }

  dynamic toJson() => {'title': title, 'juan': juan, 'juan_list': juan_list, 'work': work};
}