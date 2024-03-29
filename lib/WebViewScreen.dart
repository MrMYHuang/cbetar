import 'dart:async';
import 'dart:convert';

import 'package:cbetar/Globals.dart';
import 'package:cbetar/Utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'Bookmark.dart';
import 'Work.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';

class WebViewScreen extends StatefulWidget {
  final Work work;
  final String path;
  final String bookmarkUuid;

  WebViewScreen({super.key, required this.work, this.path = "", this.bookmarkUuid = ""});

  @override
  _WebViewScreen createState() {
    return _WebViewScreen();
  }
}

class _WebViewScreen extends State<WebViewScreen>
    with AutomaticKeepAliveClientMixin {
  var works = <Work>[];
  final url = "$cbetaApiUrl/works?work=";
  var fileName = "";

  bool get hasBookmark {
    try {
      store.state.bookmarks.firstWhere(
              (e) =>
          e.type == BookmarkType.JUAN &&
              (e.uuid == widget.bookmarkUuid || e.uuid == bookmarkNewUuid));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fileName = "${widget.work.work}_juan${widget.work.juan}.html";
    Future.delayed(Duration.zero, () {
      fetchHtml();
    });
  }

  var workHtml = "";
  final base64HtmlPrefix = 'data:text/html;charset=UTF-8;base64,';

  var fetchFail = false;

  void fetchHtml() async {
    final file = await getLocalFile(fileName);
    if (file.existsSync()) {
      final temp = await loadLocalFile(fileName);
      if (!mounted) return;
      setState(() {
        workHtml = temp;
      });
      return;
    }

    try {
      if (widget.path == "") {
        final data = await fetchData(httpClient,
            "$cbetaApiUrl/juans?edition=CBETA&work=${widget.work.work}&juan=${widget.work.juan}");

        if (!mounted) return;
        setState(() {
          workHtml = data[0] as String;
        });
      } else {
        final data =
            await downloadFile(httpClient, "$cbetaApiUrl/${widget.path}");
        final temp = String.fromCharCodes(data);
        var htmlStr = "";
        if (temp.contains("charset=big5"))
          htmlStr = await htmlBig5ToUtf8(data);
        else
          htmlStr = utf8.decode(data);

        if (!mounted) return;
        setState(() {
          workHtml = htmlStr;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        fetchFail = true;
      });
    }
  }

  void updateWebView(WebViewController controller, double fontSize,
      bool darkMode, bool showComments) async {
    final String cssStyles = '''
    <meta name = "viewport" content = "user-scalable=no, width=device-width">
      <style>
      .lb {
        display: none
      }
      #back {
        display: ${showComments ? "visible" : "none"}
      }
      .t, p {
        font-size: ${fontSize}px;
        color: ${darkMode ? "white" : "black"}
      }
      body {
        background: ${darkMode ? "black" : "white"}
      }
      </style>
      ''';

    final jsScripts = '''<script>
        var bookmarkPrefix = 'bookmark_';
        function addBookmark(uuid) {
          var sel, range;
          if (window.getSelection) {
            sel = window.getSelection();
            if (sel.rangeCount) {
              range = sel.getRangeAt(0);
              range.startContainer.parentElement.id = bookmarkPrefix + uuid;
              var msg = JSON.stringify({status: 'ok', selectedText: sel.toString(), html: document.body.outerHTML}); 
              SaveHtml.postMessage(msg);
              return;
            }
          }
    
          SaveHtml.postMessage(JSON.stringify({status: 'error'}));    
          return;
        }
        
        function delBookmark(uuid) {
          var oldBookmark = document.getElementById(bookmarkPrefix + uuid);
          if (oldBookmark) {
            oldBookmark.id = '';
          }
        }
    
        function scrollToBookmark(uuid) {
          //console.log('Bookmark uuid: ' + bookmarkPrefix + uuid);
          document.getElementById(bookmarkPrefix + uuid).scrollIntoView();
        }
      </script>
    ''';

    // Note! Place CSS and scripts before and not after <html>,
    // so document.body.outerHTML doesn't contains them.
    // And thus the saved and then loaded HTML has no them.
    // Thus, we save the checks a loaded HTML has injected CSS and scripts.
    // It simplifies this program logics.
    final workHtmlStylesScripts = cssStyles + jsScripts + workHtml;
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(workHtmlStylesScripts));
    await controller.loadUrl('$base64HtmlPrefix$contentBase64');
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  var bookmarkNewUuid = "";

  void addBookmarkHandler() {
    _controller.future.then((controller) {
      bookmarkNewUuid = Uuid().v4().toString();
      controller.evaluateJavascript("addBookmark('$bookmarkNewUuid');");
    });
  }

  void delBookmarkHandler() {
    final uuidToDel =
        (widget.bookmarkUuid == "") ? bookmarkNewUuid : widget.bookmarkUuid;
    _controller.future.then((controller) {
      controller.evaluateJavascript("delBookmark('$uuidToDel');").then((a) {
        store.dispatch(MyActions(type: ActionTypes.DEL_BOOKMARK, value: {
          "type": BookmarkType.JUAN,
          "fileName": fileName,
          "uuid": uuidToDel
        }));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(converter: (store) {
      return store.state;
    }, builder: (BuildContext context, AppState vm) {
      _controller.future.then((controller) {
        updateWebView(controller, vm.fontSize, vm.darkMode, vm.showComments);
      });
      return _webviewScreen();
    });
  }

  Widget _webviewScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.work.title}卷${widget.work.juan}"),
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
          PopupMenuButton<Choice>(
            color: Colors.black,
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(choice.icon),
                        Text(
                          "    ${choice.title}",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ));
              }).toList();
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
          : workHtml == ""
              ? Center(child: CircularProgressIndicator())
              : WebView(
                  //debuggingEnabled: true,
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: <JavascriptChannel>[
                    _saveHtmlJavascriptChannel(context),
                  ].toSet(),
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onPageFinished: (msg) {
                    _controller.future.then((controller) {
                      controller.evaluateJavascript(hasBookmark
                          ? "scrollToBookmark('${widget.bookmarkUuid != "" ? widget.bookmarkUuid : bookmarkNewUuid}')"
                          : "");
                    });
                  },
                  gestureRecognizers: {
                      Factory(() => EagerGestureRecognizer())
                    }),
    );
  }

  JavascriptChannel _saveHtmlJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'SaveHtml',
        onMessageReceived: (JavascriptMessage message) {
          final json = JsonDecoder().convert(message.message);

          if (json["status"] == 'error') {
            asyncYesDialog(context, '書籤新增失敗', '請確認是否已選擇一段文字，再新增書籤!');
            return;
          }

          workHtml = json["html"] as String;
          final selectedText = json["selectedText"] as String;
          final bookmarkNew = Bookmark(
              type: BookmarkType.JUAN,
              uuid: bookmarkNewUuid,
              work: widget.work,
              selectedText: selectedText,
              fileName: fileName);
          store.dispatch(MyActions(type: ActionTypes.ADD_BOOKMARK, value: {
            "fileName": fileName,
            "htmlStr": workHtml,
            "bookmark": bookmarkNew
          }));
        });
  }

  void refreshButtonAction() async {
    final ok =
        await asyncYesNoDialog(context, '確定更新經文?', '更新經文會刪除此經文所有書籤!\n確定執行?');
    if (ok == true) {
      fetchFail = false;
      delFile(fileName);
      // Unfortunately, HTML bookmarks are lost after updating a stored HTML file.
      // Thus, we also delete all its bookmarks in state.json.
      store.dispatch(MyActions(type: ActionTypes.DEL_BOOKMARKS, value: {
        "fileName": fileName,
      }));
      fetchHtml();
    }
  }

  void gotoHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _select(Choice choice) {
    switch (choice.type) {
      case MenuActions.refresh:
        refreshButtonAction();
        break;
      case MenuActions.home:
        gotoHome();
        break;
      case MenuActions.search:
        searchCbeta(context);
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class Choice {
  const Choice({required this.type, required this.title, required this.icon});

  final MenuActions type;
  final String title;
  final IconData icon;
}

enum MenuActions {
  refresh,
  home,
  search,
}

const List<Choice> choices = const <Choice>[
  const Choice(type: MenuActions.refresh, title: '更新', icon: Icons.refresh),
  const Choice(type: MenuActions.home, title: '首頁', icon: Icons.home),
  const Choice(type: MenuActions.search, title: '搜尋', icon: Icons.search),
];
