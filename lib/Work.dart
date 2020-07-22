import 'package:cbetar/Utilities.dart';

class Work extends Model {
  int juan;
  String juan_list;
  String work;

  Work({this.juan, this.juan_list, this.work}) : super(null);

  @override
  Work.fromJson(Map<String, dynamic> json) : super(null) {
    this.juan = json["juan"];
    this.juan_list = json["juan_list"];
    this.work = json["work"];
  }
}