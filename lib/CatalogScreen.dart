import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';

import 'Catalog.dart';
import 'WorkScreen.dart';

class CatalogScreen extends StatefulWidget {
  final String path;

  CatalogScreen({Key key, this.path}) : super(key: key);

  @override
  _CatalogScreen createState() {
    return _CatalogScreen();
  }
}

class _CatalogScreen extends State<CatalogScreen>
    with AutomaticKeepAliveClientMixin {
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
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.path),
          ),
          body: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 1,
              ),
              itemCount: catalogs.length,
              itemBuilder: (BuildContext context, int index) {
                // access element from list using index
                // you can create and return a widget of your choice
                return GestureDetector(
                  child: Text(
                    catalogs[index].label,
                    style: TextStyle(fontSize: 40),
                  ),
                  onTap: () {
                    if (catalogs[index].work == null) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                CatalogScreen(path: catalogs[index].n)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                WorkScreen(work: catalogs[index].work)),
                      );
                    }
                  },
                );
              }));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
