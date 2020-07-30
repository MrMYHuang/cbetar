import 'package:cbetar/Utilities.dart';

class Catalog extends Model {
  String n;
  String nodeType;
  String label;
  String work;
  String file;

  Catalog({this.n, this.nodeType, this.label, this.work, this.file}) : super(null);

  @override
  Catalog.fromJson(Map<String, dynamic> json) : super(null) {
    this.n = json["n"];
    this.nodeType = json["node_type"];
    this.label = json["label"];
    this.work = json["work"];
    this.file = json["file"];
  }
}