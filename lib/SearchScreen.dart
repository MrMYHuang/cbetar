import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'CatalogScreen.dart';
import 'Globals.dart';
import 'Redux.dart';

import 'Search.dart';
import 'WorkScreen.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;

  SearchScreen({super.key, required this.keyword});

  @override
  _SearchScreen createState() {
    return _SearchScreen();
  }
}

class _SearchScreen extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  List<Search>? searches;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      search(widget.keyword);
    });
  }

  final searchUrl = "$cbetaApiUrl/toc?q=";

  void search(String text) async {
    try {
      final data = await fetchData(httpClient, searchUrl + text);

      if (!mounted) return;
      setState(() {
        searches = <Search>[];
        data.forEach((element) {
          searches!.add(Search.fromJson(element as Map<String, dynamic>));
        });
      });
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('連線逾時!請檢查網路!'),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          backgroundColor: Colors.blueAccent,
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
                itemCount: searches!.length,
                itemBuilder: (BuildContext context, int index) {
                  // access element from list using index
                  bool isCatalog = searches![index].type == 'catalog';
                  // you can create and return a widget of your choice
                  return GestureDetector(
                    child: Text(
                      isCatalog
                          ? searches![index].label
                          : "${searches![index].title}\n作者:${searches![index].creators}",
                      style: TextStyle(fontSize: vm.listFontSize),
                    ),
                    onTap: () {
                      if (isCatalog) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  CatalogScreen(path: searches![index].n, label: searches![index].label,)),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  WorkScreen(work: searches![index].work)),
                        );
                      }
                    },
                  );
                },
              ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
