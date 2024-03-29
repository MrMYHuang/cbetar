import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'Redux.dart';
import 'Globals.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreen createState() {
    return _SettingScreen();
  }
}

class _SettingScreen extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();

    loadVersionInfo();
  }

  var _projectVersion = "";

  void loadVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var projectVersion = "";
    try {
      projectVersion = packageInfo.version;
    } catch (e) {}

    if (!mounted) return;
    setState(() {
      _projectVersion = projectVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SettingScreenViewModel>(
        converter: (store) {
      return _SettingScreenViewModel(
        state: store.state,
        onChanged: (value) => store.dispatch(
            MyActions(type: ActionTypes.CHANGE_FONT_SIZE, value: value)),
        onListFontSizeChanged: (value) => store.dispatch(
            MyActions(type: ActionTypes.CHANGE_LIST_FONT_SIZE, value: value)),
        onDarkModeChanged: (value) => store.dispatch(
            MyActions(type: ActionTypes.CHANGE_DARK_MODE, value: value)),
        onCommentModeChanged: (value) => store.dispatch(
            MyActions(type: ActionTypes.CHANGE_COMMENT_MODE, value: value)),
      );
    }, builder: (BuildContext context, _SettingScreenViewModel vm) {
      return Scaffold(
        appBar: AppBar(
          title: Text("設定"),
          backgroundColor: Colors.blueAccent,
        ),
        body: ListView(
          children: ListTile.divideTiles(
            context: context,
            color: vm.state.darkMode ? Colors.white : Colors.black,
            tiles: <Widget>[
              ListTile(
                leading: Icon(Icons.brightness_2),
                title: Text('暗色模式', style: TextStyle(fontSize: fontSizeNorm)),
                trailing: Switch(
                  value: vm.state.darkMode,
                  onChanged: vm.onDarkModeChanged,
                  activeColor: Colors.blueAccent,
                ),
              ),
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('顯示註腳', style: TextStyle(fontSize: fontSizeNorm)),
                trailing: Switch(
                  value: vm.state.showComments,
                  onChanged: vm.onCommentModeChanged,
                  activeColor: Colors.blueAccent,
                ),
              ),
              ListTile(
                leading: Icon(Icons.format_size),
                title: Slider(
                    value: vm.state.listFontSize,
                    min: 10,
                    max: 64,
                    divisions: (64 - 10),
                    onChanged: vm.onListFontSizeChanged),
                subtitle: Text(
                  '列表字型大小:${vm.state.listFontSize}',
                  style: TextStyle(fontSize: vm.state.listFontSize),
                ),
              ),
              ListTile(
                leading: Icon(Icons.format_size),
                title: Slider(
                    value: vm.state.fontSize,
                    min: 10,
                    max: 64,
                    divisions: (64 - 10),
                    onChanged: vm.onChanged),
                subtitle: Text(
                  '經文字型大小:${vm.state.fontSize}',
                  style: TextStyle(fontSize: vm.state.fontSize),
                ),
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text(
                  '特色',
                  style: TextStyle(fontSize: fontSizeNorm),
                ),
                subtitle: Text(
                  '搜尋經文、書籤功能、離線瀏覽、暗色模式、字型調整。',
                  style: TextStyle(fontSize: fontSizeNorm),
                ),
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text(
                  '關於',
                  style: TextStyle(fontSize: fontSizeNorm),
                ),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '程式版本: $_projectVersion',
                        style: TextStyle(fontSize: fontSizeNorm),
                      ),
                      Text(
                        'CBETA API版本: $apiVersion',
                        style: TextStyle(fontSize: fontSizeNorm),
                      ),
                      Text(
                        '作者: Meng-Yuan Huang',
                        style: TextStyle(fontSize: fontSizeNorm),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'myh@live.com',
                          style: TextStyle(
                              color: Colors.blue, fontSize: fontSizeNorm),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(scheme: 'mailto', path: 'myh@live.com'));
                            },
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: '操作說明與開放原始碼',
                          style: TextStyle(
                              color: Colors.blue, fontSize: fontSizeNorm),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(scheme: 'https', host: 'github.com', path: '/MrMYHuang/cbetar'));
                            },
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'CBETA API參考文件',
                          style: TextStyle(
                              color: Colors.blue, fontSize: fontSizeNorm),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri(scheme: 'https', host: 'cbdata.dila.edu.tw', path: 'stable'));
                            },
                        ),
                      )
                    ]),
              ),
            ],
          ).toList(),
        ),
      );
    });
  }
}

class _SettingScreenViewModel {
  final AppState state;
  final void Function(double value) onChanged;
  final void Function(double value) onListFontSizeChanged;
  final void Function(bool value) onDarkModeChanged;
  final void Function(bool value) onCommentModeChanged;

  _SettingScreenViewModel({
    required this.state,
    required this.onChanged,
    required this.onListFontSizeChanged,
    required this.onDarkModeChanged,
    required this.onCommentModeChanged,
  });
}
