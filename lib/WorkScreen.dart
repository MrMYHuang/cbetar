import 'dart:async';
import 'dart:convert';

import 'package:cbetar/Utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'WebViewScreen.dart';
import 'Work.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';
import 'Globals.dart';

class WorkScreen extends StatefulWidget {
  final String work;

  WorkScreen({Key key, this.work}) : super(key: key);

  @override
  _WorkScreen createState() {
    return _WorkScreen();
  }
}

class _WorkScreen extends State<WorkScreen> with AutomaticKeepAliveClientMixin {
  var works = List<Work>();
  final client = http.Client();
  final url = "http://cbdata.dila.edu.tw/v1.2/works?work=";

  @override
  void initState() {
    super.initState();
    fetch();
  }

  var juans = List<String>();

  void fetch() async {
    final data = await fetchData(client, url + widget.work);

    works = List<Work>();
    data.forEach((element) {
      works.add(Work.fromJson(element));
    });
    setState(() {
      juans = works[0].juan_list.split(",").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.work),
          ),
          body: ListView.builder(
              addRepaintBoundaries: true,
              itemCount: juans.length,
              itemBuilder: (BuildContext context, int index) {
                // access element from list using index
                // you can create and return a widget of your choice
                return GestureDetector(
                  child: Text(
                    "卷${juans[index]}",
                    style: TextStyle(fontSize: vm.fontSize),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              WebViewScreen(work: widget.work, juan: juans[index])),
                    );
                  },
                );
              }));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
