import 'package:cbetar/CatalogScreen.dart';
import 'package:cbetar/BookmarkScreen.dart';
import 'SettingScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'Redux.dart';
import 'Globals.dart';

Map<String, dynamic> reducer(Map<String, dynamic> state, dynamic action) {
  if (action.type == ActionTypes.CHANGE_FONT_SIZE) {
    state["fontSize"] = action.value;
  }

  return state;
}

void main() {
  final initState = Map<String, dynamic>();
  initState["fontSize"] = 32.0;
  final store = Store<Map<String, dynamic>>(reducer, initialState: initState);
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<Map<String, dynamic>> store;

  MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<Map<String, dynamic>>(
      store: store,
      child: MaterialApp(
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Navigator(
                onGenerateRoute: (RouteSettings routeSettings) {
                  return MaterialPageRoute(
                      builder: (context) => CatalogScreen(path: "CBETA"));
                },
              ),
                BookmarkScreen(),
                SettingScreen(),
              ],
            ),
            bottomNavigationBar: Container(
              color: Color(0xFF3F5AA6),
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.search)),
                  Tab(icon: Icon(Icons.favorite)),
                  Tab(icon: Icon(Icons.settings)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
