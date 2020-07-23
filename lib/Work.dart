import 'package:cbetar/Utilities.dart';

class Work extends Model {
  String title;
  int juan;
  String juan_list;
  String work;

  Work({this.title, this.juan, this.juan_list, this.work}) : super(null);

  @override
  Work.fromJson(Map<String, dynamic> json) : super(null) {
    this.title = json["title"];
    this.juan = json["juan"];
    this.juan_list = json["juan_list"];
    this.work = json["work"];
  }
}