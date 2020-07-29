import 'dart:io';

import 'package:cbetar/CatalogScreen.dart';
import 'package:cbetar/BookmarkScreen.dart';
import 'package:cbetar/Globals.dart';
import 'package:cbetar/Utilities.dart';
import 'SettingScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';

import 'Redux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final persistor = Persistor<AppState>(
    storage: FileStorage(await getLocalFile('state.json')),
    // Or use other engines
    serializer:
        JsonSerializer<AppState>(AppState.fromJson), // Or use other serializers
  );

  final initialState = await persistor.load();
  store = Store<AppState>(reducer,
      initialState: initialState ?? AppState(),
      middleware: [persistor.createMiddleware()]);
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  final GlobalKey<NavigatorState> bookmarkNavigatorKey = GlobalKey();
  final GlobalKey<NavigatorState> catalogNavigatorKey = GlobalKey();

  MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: DefaultTabController(
          length: 3,
          child: Builder(builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                switch (DefaultTabController.of(context).index) {
                  case 0:
                    if (bookmarkNavigatorKey.currentState.canPop())
                      bookmarkNavigatorKey.currentState.pop();
                    break;
                  case 1:
                    if (catalogNavigatorKey.currentState.canPop())
                      catalogNavigatorKey.currentState.pop();
                    break;
                }
                return false;
              },
              child: Scaffold(
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Navigator(
                      key: bookmarkNavigatorKey,
                      onGenerateRoute: (RouteSettings routeSettings) {
                        return MaterialPageRoute(
                            builder: (context) => BookmarkScreen());
                      },
                    ),
                    Navigator(
                      key: catalogNavigatorKey,
                      onGenerateRoute: (RouteSettings routeSettings) {
                        return MaterialPageRoute(
                            builder: (context) => CatalogScreen(path: "CBETA"));
                      },
                    ),
                    SettingScreen(),
                  ],
                ),
                bottomNavigationBar: Container(
                  color: Colors.blueAccent,
                  child: TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.bookmark)),
                      Tab(icon: Icon(Icons.library_books)),
                      Tab(icon: Icon(Icons.settings)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
