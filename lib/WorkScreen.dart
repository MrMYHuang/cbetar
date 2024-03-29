import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';

import 'Bookmark.dart';
import 'Globals.dart';
import 'WebViewScreen.dart';
import 'Work.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';

class WorkScreen extends StatefulWidget {
  final String work;

  WorkScreen({super.key, required this.work});

  @override
  _WorkScreen createState() {
    return _WorkScreen();
  }
}

class _WorkScreen extends State<WorkScreen> with AutomaticKeepAliveClientMixin {
  List<Work>? works;
  var title = "";

  bool get workFetchDone => works != null;
  final url = "$cbetaApiUrl/works?work=";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetch();
    });
  }

  var juans = <String>[];

  var fetchFail = false;

  void fetch() async {
    try {
      final data = await fetchData(httpClient, url + widget.work);

      works = <Work>[];
      data.forEach((element) {
        works!.add(Work.fromJson(element));
      });
      if (!mounted) return;
      setState(() {
        title = works![0].title;
        juans = works![0].juan_list.split(",").toList();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        fetchFail = true;
      });
    }
  }

  bool get hasBookmark {
    try {
      (store.state).bookmarks.firstWhere(
              (e) =>
          e.type == BookmarkType.WORK && e.work!.work == widget.work);
      return true;
    } catch (e) {
      return false;
    }
  }

  void addBookmarkHandler() {
    store.dispatch(MyActions(type: ActionTypes.ADD_BOOKMARK, value: {
      "bookmark": Bookmark(type: BookmarkType.WORK, work: Work(work: widget.work, title: title))
    }));
  }

  void delBookmarkHandler() {
    store.dispatch(MyActions(type: ActionTypes.DEL_BOOKMARK, value: {
      "type": BookmarkType.WORK,
      "work": widget.work,
    }));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      return Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Colors.blueAccent,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.bookmark),
                color: hasBookmark ? Colors.red : Colors.white,
                onPressed: () {
                  if (!hasBookmark) {
                    addBookmarkHandler();
                  } else {
                    delBookmarkHandler();
                  }
                },
              ),
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
              : !workFetchDone
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: vm.darkMode ? Colors.white : Colors.black,
                            thickness: 1,
                          ),
                      itemCount: juans.length,
                      itemBuilder: (BuildContext context, int index) {
                        // access element from list using index
                        // you can create and return a widget of your choice
                        return GestureDetector(
                          child: Text(
                            "卷${juans[index]}",
                            style: TextStyle(fontSize: vm.listFontSize),
                          ),
                          onTap: () {
                            var work = works![0];
                            work.juan = int.parse(juans[index]);
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          WebViewScreen(work: work)),
                            );
                          },
                        );
                      }));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
