import 'package:cbetar/Utilities.dart';

class Catalog extends Model {
  String n;
  String label;

  Catalog({this.n, this.label}) : super(null);

  @override
  Catalog.fromJson(Map<String, dynamic> json) : super(null) {
    this.n = json["n"];
    this.label = json["label"];
  }
}