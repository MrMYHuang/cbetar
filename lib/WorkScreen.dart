import 'dart:async';
import 'dart:convert';

import 'package:cbetar/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Work.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';

class WorkScreen extends StatefulWidget {
  final String path;

  WorkScreen({Key key, this.path}) : super(key: key);

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

  void fetch() async {
    final data = await fetchData(client, url + widget.path);

    works = List<Work>();
    data.forEach((element) {
      works.add(Work.fromJson(element));
    });
    fetchHtml();
  }

  final htmlUrl =
      "http://cbdata.dila.edu.tw/v1.2/juans?juan=1&edition=CBETA&work=";
  var workHtml = "";

  void fetchHtml() async {
    final data = await fetchData(client, htmlUrl + widget.path);
    setState(() {
      workHtml = data[0];
    });
  }

  void updateWebView(WebViewController controller, double fontSize) {
    final String styles = '''
    <style>
    .lb {
      display: none
    }
    .t {
      font-size: ${fontSize}px
    }
    </style>
    ''';
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(styles + workHtml));
    controller.loadUrl('data:text/html;base64,$contentBase64');
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<Map<String, dynamic>, MyState>(converter: (store) {
      return MyState(
        state: store.state,
      );
    }, builder: (BuildContext context, MyState vm) {
      _controller.future.then((controller) {
        updateWebView(controller, vm.state["fontSize"]);
      });
      return WebView(
        //initialUrl: 'https://flutter.dev',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
