import 'package:cbetar/Utilities.dart';

class Catalog extends Model {
  String n;
  String label;
  String work;

  Catalog({this.n, this.label, this.work}) : super(null);

  @override
  Catalog.fromJson(Map<String, dynamic> json) : super(null) {
    this.n = json["n"];
    this.label = json["label"];
    this.work = json["work"];
  }
}