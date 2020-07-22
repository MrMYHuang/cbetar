import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Catalog.dart';

class BookScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookScreen();
  }
}

class _BookScreen extends State<BookScreen> {
  List<Catalog> catalogs = List<Catalog>();
  final client = http.Client();
  final url = "http://cbdata.dila.edu.tw/v1.2/catalog_entry?q=CBETA";

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    final data = await fetchData(client, url);

    setState(() {
      catalogs = List<Catalog>();
      data.forEach((element) {
        catalogs.add(Catalog.fromJson(element));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: catalogs.length,
        itemBuilder: (BuildContext context, int index) {
          // access element from list using index
          // you can create and return a widget of your choice
          return Text(
            catalogs[index].label
          );
        }
    );
  }
}
