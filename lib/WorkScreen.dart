import 'package:cbetar/Utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Globals.dart';
import 'SearchScreen.dart';
import 'WebViewScreen.dart';
import 'Work.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';

class WorkScreen extends StatefulWidget {
  final String work;

  WorkScreen({Key key, this.work}) : super(key: key);

  @override
  _WorkScreen createState() {
    return _WorkScreen();
  }
}

class _WorkScreen extends State<WorkScreen> with AutomaticKeepAliveClientMixin {
  List<Work> works;
  var title = "";
  bool get workFetchDone => works != null;
  final url = "${cbetaApiUrl}/works?work=";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetch();
    });
  }

  var juans = List<String>();

  var fetchFail = false;

  void fetch() async {
    try {
      final data = await fetchData(httpClient, url + widget.work);

      works = List<Work>();
      data.forEach((element) {
        works.add(Work.fromJson(element));
      });
      if (!mounted) return;
      setState(() {
        title = works[0].title;
        juans = works[0].juan_list.split(",").toList();
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
            title: Text(title),
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
              : !workFetchDone
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                      itemCount: juans.length,
                      itemBuilder: (BuildContext context, int index) {
                        // access element from list using index
                        // you can create and return a widget of your choice
                        return GestureDetector(
                          child: Text(
                            "卷${juans[index]}",
                            style: TextStyle(fontSize: 40),
                          ),
                          onTap: () {
                            var work = works[0];
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
