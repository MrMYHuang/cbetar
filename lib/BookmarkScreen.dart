import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'Globals.dart';
import 'Redux.dart';
import 'WebViewScreen.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  _BookmarkScreen createState() {
    return _BookmarkScreen();
  }
}

class _BookmarkScreen extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      return Scaffold(
          appBar: AppBar(
            title: Text("書籤"),
            backgroundColor: Colors.blueAccent,
          ),
          body: vm.bookmarks.length == 0
              ? Center(
                  child: Text(
                    '無書籤',
                    style: TextStyle(fontSize: fontSizeLarge),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: vm.darkMode ? Colors.white : Colors.black,
                        thickness: 1,
                      ),
                  itemCount: vm.bookmarks.length,
                  itemBuilder: (BuildContext context, int index) {
                    // access element from list using index
                    // you can create and return a widget of your choice
                    final bookmark = vm.bookmarks[index];
                    return GestureDetector(
                      child: Text(
                        "${bookmark.work.title}第${bookmark.work.juan}卷\n${bookmark.selectedText}",
                        style: TextStyle(fontSize: vm.listFontSize),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  WebViewScreen(
                                      work: vm.bookmarks[index].work,
                                      bookmarkUuid: vm.bookmarks[index].uuid)),
                        );
                      },
                    );
                  }));
    });
  }
}
