import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_redux/flutter_redux.dart';
import 'CatalogScreen.dart';
import 'Globals.dart';
import 'Redux.dart';

import 'Search.dart';
import 'Work.dart';
import 'WorkScreen.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;

  SearchScreen({Key key, this.keyword}) : super(key: key);

  @override
  _SearchScreen createState() {
    return _SearchScreen();
  }
}

class _SearchScreen extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  List<Search> searches;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      search(widget.keyword);
    });
  }

  final searchUrl = "${cbetaApiUrl}/toc?q=";

  void search(String text) async {
    try {
      final data = await fetchData(httpClient, searchUrl + text);

      if (!mounted) return;
      setState(() {
        searches = List<Search>();
        data.forEach((element) {
          searches.add(Search.fromJson(element));
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
      return Scaffold(
          appBar: AppBar(
            title: Text("搜尋 - ${widget.keyword}"),
            actions: <Widget>[
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
          body: searches == null
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: vm.darkMode ? Colors.white : Colors.black,
                        thickness: 1,
                      ),
                  itemCount: searches.length,
                  itemBuilder: (BuildContext context, int index) {
                    // access element from list using index
                    bool isCatalog = searches[index].type == 'catalog';
                    // you can create and return a widget of your choice
                    return GestureDetector(
                      child: Text(
                        isCatalog
                            ? searches[index].label
                            : "${searches[index].title}\n作者:${searches[index].creators ?? "?"}",
                        style: TextStyle(fontSize: 40),
                      ),
                      onTap: () {
                        if (isCatalog) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        CatalogScreen(path: searches[index].n)),
                          );
                        } else {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        WorkScreen(work: searches[index].work)),
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
