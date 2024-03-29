import 'package:cbetar/Utilities.dart';

class Search extends Model {
  late String type;
  late String n;
  late String label;
  late String work;
  late String title;
  late String creators;

  Search(this.type, this.n, this.label, this.work, this.title, this.creators) : super(null);

  @override
  Search.fromJson(Map<String, dynamic> json) : super(null) {
    this.type = json["type"];
    this.n = json["n"];
    this.label = json["label"];
    this.work = json["work"];
    this.title = json["title"];
    this.creators = json["creators"];
  }
}