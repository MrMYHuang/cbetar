import 'package:cbetar/Utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Globals.dart';
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
  final client = http.Client();
  final url = "${cbetaApiUrl}/works?work=";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetch();
    });
  }

  var juans = List<String>();

  void fetch() async {
    try {
      final data = await fetchData(client, url + widget.work);

      works = List<Work>();
      data.forEach((element) {
        works.add(Work.fromJson(element));
      });
      setState(() {
        juans = works[0].juan_list.split(",").toList();
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
      return works == null ? Center(child: CircularProgressIndicator()) : Scaffold(
          appBar: AppBar(
            title: Text(widget.work),
          ),
          body: ListView.separated(
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
                          pageBuilder: (context, animation1, animation2) =>
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
