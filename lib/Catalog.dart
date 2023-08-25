import 'package:cbetar/Utilities.dart';

class Catalog extends Model {
  late String n;
  late String? nodeType;
  late String label;
  late String? work;
  late String? file;

  Catalog({required this.n, required this.nodeType, required this.label, this.work, this.file}) : super(null);

  @override
  Catalog.fromJson(Map<String, dynamic> json) : super(null) {
    this.n = json["n"];
    this.nodeType = json["node_type"];
    this.label = json["label"];
    this.work = json["work"];
    this.file = json["file"];
  }
}