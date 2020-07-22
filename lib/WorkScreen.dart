import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Work.dart';
import 'Work.dart';

class WorkScreen extends StatefulWidget {
  final String path;

  WorkScreen({Key key, this.path}) : super(key: key);

  @override
  _WorkScreen createState() {
    return _WorkScreen();
  }
}

class _WorkScreen extends State<WorkScreen> {

  var works = List<Work>();
  final client = http.Client();
  final url = "http://cbdata.dila.edu.tw/v1.2/works?work=";

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    final data = await fetchData(client, url + widget.path);

    setState(() {
      works = List<Work>();
      data.forEach((element) {
        works.add(Work.fromJson(element));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: works.length,
        itemBuilder: (BuildContext context, int index) {
          // access element from list using index
          // you can create and return a widget of your choice
          return GestureDetector(
            child: Text(works[index].juan_list),
            onTap: () {
            },
          );
        });
  }
}
