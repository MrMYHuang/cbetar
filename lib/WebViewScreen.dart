import 'dart:async';
import 'dart:convert';

import 'package:cbetar/Globals.dart';
import 'package:cbetar/Utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'Boormark.dart';
import 'Work.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';

class WebViewScreen extends StatefulWidget {
  final Work work;
  final String bookmarkUuid;

  WebViewScreen({Key key, this.work, this.bookmarkUuid = ""}) : super(key: key);

  @override
  _WebViewScreen createState() {
    return _WebViewScreen();
  }
}

class _WebViewScreen extends State<WebViewScreen>
    with AutomaticKeepAliveClientMixin {
  var works = List<Work>();
  final client = http.Client();
  final url = "${cbetaApiUrl}/works?work=";
  var fileName = "";

  bool hasBookmark;

  @override
  void initState() {
    super.initState();
    hasBookmark = (widget.bookmarkUuid != "");
    fileName = "${widget.work.work}_juan${widget.work.juan}.html";
    Future.delayed(Duration.zero, () {
      fetchHtml();
    });
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

    try {
      final data = await fetchData(client,
          "${cbetaApiUrl}/juans?edition=CBETA&work=${widget.work.work}&juan=${widget.work.juan}");

      saveFile(fileName, data[0]);
      setState(() {
        workHtml = data[0];
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

  void updateWebView(WebViewController controller, double fontSize) async {
    var scrollToBookmark = '';
    if (widget.bookmarkUuid != "") {
      scrollToBookmark = '''
      <script>
      scrollToBookmark('${widget.bookmarkUuid}');
      </script>
      ''';
    }
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
    var bookmarkPrefix = 'bookmark_';
    function addBookmark(uuid) {
      var sel, range;
      if (window.getSelection) {
        sel = window.getSelection();
        if (sel.rangeCount) {
          range = sel.getRangeAt(0);
          range.startContainer.parentElement.id = bookmarkPrefix + uuid;
          var msg = JSON.stringify({selectedText: sel.toString(), html: document.body.outerHTML}) 
          SaveHtml.postMessage(msg);
        }
      }
    }
    
    function delBookmark(uuid) {
      var oldBookmark = document.getElementById(bookmarkPrefix + uuid);
      if (oldBookmark) {
        oldBookmark.id = '';
      }
    }

    function scrollToBookmark(uuid) {
      document.getElementById(bookmarkPrefix + uuid).scrollIntoView();
    }
  </script>
    ''';
    final String contentBase64 = base64Encode(
        const Utf8Encoder().convert(styles + workHtml + scrollToBookmark));
    await controller.loadUrl('$base64HtmlPrefix$contentBase64');
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  var bookmarkNewUuid = "";

  void addBookmarkHandler() {
    _controller.future.then((controller) {
      bookmarkNewUuid = Uuid().v4().toString();
      controller.evaluateJavascript("addBookmark('${bookmarkNewUuid}');");
      setState(() {
        hasBookmark = true;
      });
    });
  }

  void delBookmarkHandler() {
    final uuidToDel =
        (widget.bookmarkUuid == "") ? bookmarkNewUuid : widget.bookmarkUuid;
    _controller.future.then((controller) {
      controller.evaluateJavascript("delBookmark('${uuidToDel}');").then((a) {
        setState(() {
          hasBookmark = false;
        });
        store.dispatch(
            MyActions(type: ActionTypes.DEL_BOOKMARK, value: uuidToDel));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      _controller.future.then((controller) {
        updateWebView(controller, vm.fontSize);
      });
      return workHtml == ""
          ? Center(child: CircularProgressIndicator())
          : _webviewScreen();
    });
  }

  Widget _webviewScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.work.title} - 第${widget.work.juan}卷"),
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
          final json = JsonDecoder().convert(message.message);
          final htmlStr = json["html"] as String;
          final selectedText = json["selectedText"] as String;
          saveFile(fileName, htmlStr);
          final bookmarkNew = Bookmark(
              uuid: bookmarkNewUuid,
              work: widget.work,
              selectedText: selectedText);
          store.dispatch(
              MyActions(type: ActionTypes.ADD_BOOKMARK, value: bookmarkNew));
        });
  }

  @override
  bool get wantKeepAlive => true;
}
