import 'dart:io';

import 'package:cbetar/CatalogScreen.dart';
import 'package:cbetar/BookmarkScreen.dart';
import 'package:cbetar/Utilities.dart';
import 'SettingScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';

import 'Redux.dart';

AppState reducer(AppState state, dynamic action) {
  if (action.type == ActionTypes.CHANGE_FONT_SIZE) {
    return AppState(fontSize: action.value);
  }

  return state;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final persistor = Persistor<AppState>(
    storage: FileStorage(await getLocalFile('state.json')), // Or use other engines
    serializer: JsonSerializer<AppState>(AppState.fromJson), // Or use other serializers
  );

  final initialState = await persistor.load();
  final store = Store<AppState>(
      reducer,
      initialState: initialState ?? AppState(),
      middleware: [persistor.createMiddleware()]);
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
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
