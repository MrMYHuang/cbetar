import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';

import 'Catalog.dart';
import 'WorkScreen.dart';

class BookScreen extends StatefulWidget {
  final String path;

  BookScreen({Key key, this.path}) : super(key: key);

  @override
  _BookScreen createState() {
    return _BookScreen();
  }
}

class _BookScreen extends State<BookScreen> {
  List<Catalog> catalogs = List<Catalog>();
  final client = http.Client();
  final url = "http://cbdata.dila.edu.tw/v1.2/catalog_entry?q=";

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    final data = await fetchData(client, url + widget.path);

    setState(() {
      catalogs = List<Catalog>();
      data.forEach((element) {
        catalogs.add(Catalog.fromJson(element));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<Map<String, dynamic>, MyState>(converter: (store) {
      return MyState(
        state: store.state,
      );
    }, builder: (BuildContext context, MyState vm) {
      return ListView.builder(
          itemCount: catalogs.length,
          itemBuilder: (BuildContext context, int index) {
            // access element from list using index
            // you can create and return a widget of your choice
            return GestureDetector(
              child: Text(catalogs[index].label, style: TextStyle(fontSize: vm.state["fontSize"]),),
              onTap: () {
                if (catalogs[index].work == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookScreen(path: catalogs[index].n)),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WorkScreen(path: catalogs[index].work)),
                  );
                }
              },
            );
          });
    });
  }
}
