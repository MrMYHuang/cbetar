import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'Globals.dart';
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
  List<Catalog> catalogs;
  final client = http.Client();
  final url = "${cbetaApiUrl}/catalog_entry?q=";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetch();
    });
  }

  void fetch() async {
    try {
      final data = await fetchData(client, url + widget.path);

      if (!mounted) return;
      setState(() {
        catalogs = List<Catalog>();
        data.forEach((element) {
          catalogs.add(Catalog.fromJson(element));
        });
      });
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('連線逾時!請檢查網路!'),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      return catalogs == null ? Center(child: CircularProgressIndicator()) : Scaffold(
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
