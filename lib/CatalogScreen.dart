import 'package:cbetar/Utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'Globals.dart';
import 'Redux.dart';

import 'Catalog.dart';
import 'SearchScreen.dart';
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

  var fetchFail = false;

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
      if (!mounted) return;
      setState(() {
        fetchFail = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      return Scaffold(
          appBar: AppBar(
            title: Text("目錄"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  fetchFail = false;
                  fetch();
                },
              ),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () async {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  searchCbeta(context);
                },
              ),
            ],
          ),
          body: fetchFail
              ? Center(
                  child: Text(
                    '網路連線異常!',
                    style: TextStyle(fontSize: fontSizeLarge),
                  ),
                )
              : catalogs == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
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
                                    pageBuilder: (context, animation1,
                                            animation2) =>
                                        CatalogScreen(path: catalogs[index].n)),
                              );
                            } else {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, animation1,
                                            animation2) =>
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
