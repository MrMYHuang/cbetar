import 'dart:async';
import 'dart:convert';

import 'package:cbetar/Utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Work.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';
import 'Globals.dart';

class WebViewScreen extends StatefulWidget {
  final String work;
  final String juan;

  WebViewScreen({Key key, this.work, this.juan}) : super(key: key);

  @override
  _WebViewScreen createState() {
    return _WebViewScreen();
  }
}

class _WebViewScreen extends State<WebViewScreen> with AutomaticKeepAliveClientMixin {
  var works = List<Work>();
  final client = http.Client();
  final url = "http://cbdata.dila.edu.tw/v1.2/works?work=";
  var fileName = "";

  @override
  void initState() {
    super.initState();
    fileName = "${widget.work}_juan${widget.juan}.html";
    fetchHtml();
  }

  var workHtml = "";
  final base64HtmlPrefix = 'data:text/html;base64,';

  void fetchHtml() async {
    final file = await getLocalFile(fileName);
    if (file.existsSync()) {
      final temp = await loadLocalFile(fileName);
      setState(() {
        workHtml = temp;
      });
      return;
    }

    final data = await fetchData(client, "http://cbdata.dila.edu.tw/v1.2/juans?edition=CBETA&work=${widget.work}&juan=${widget.juan}");

    saveFile(fileName, data[0]);
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
  <script>
    var bookmarkId = 'cbetarBookmark';
    function replaceBookmark() {
      var oldBookmark = document.getElementById(bookmarkId);
      if (oldBookmark) {
        oldBookmark.id = '';
      }

      var sel, range;
      if (window.getSelection) {
        sel = window.getSelection();
        if (sel.rangeCount) {
          range = sel.getRangeAt(0);
          range.startContainer.parentElement.id = bookmarkId;
        }
      }
    }

    function scrollToBookmark() {
      document.getElementById(bookmarkId).scrollIntoView();
    }
  </script>
    ''';
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(styles + workHtml));
    controller.loadUrl('$base64HtmlPrefix$contentBase64');
  }

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  void bookmarkHandler() {
    _controller.future.then((controller) {
      controller.evaluateJavascript("replaceBookmark()");
      controller.evaluateJavascript(
          "SaveHtml.postMessage(document.body.outerHTML)");
    });
  }

  void scrollToBookmarkHandler() {
    _controller.future.then((controller) {
      controller.evaluateJavascript("scrollToBookmark()");
    });
  }

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
      return workHtml == ""
          ? Center(child: CircularProgressIndicator())
          : _webviewScreen();
    });
  }

  Widget _webviewScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('CBETA閱讀器'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              bookmarkHandler();
            },
          ),
          IconButton(
            icon: Icon(Icons.pin_drop),
            onPressed: () {
              scrollToBookmarkHandler();
            },
          ),
        ],
      ),
      body: WebView(
        //initialUrl: 'https://flutter.dev',
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: <JavascriptChannel>[
            _saveHtmlJavascriptChannel(context),
          ].toSet(),
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          gestureRecognizers: {Factory(() => EagerGestureRecognizer())}),
    );
  }

  JavascriptChannel _saveHtmlJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'SaveHtml',
        onMessageReceived: (JavascriptMessage message) {
          saveFile(fileName, message.message);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
