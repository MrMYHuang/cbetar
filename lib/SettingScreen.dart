import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Redux.dart';
import 'Globals.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreen createState() {
    return _SettingScreen();
  }
}

class _SettingScreen extends State<SettingScreen> {
  double fontSize = 32;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SettingScreenViewModel>(
        converter: (store) {
      return _SettingScreenViewModel(
        state: store.state,
        onChanged: (value) => store.dispatch(
            MyActions(type: ActionTypes.CHANGE_FONT_SIZE, value: value)),
      );
    }, builder: (BuildContext context, _SettingScreenViewModel vm) {
      return Scaffold(
        appBar: AppBar(
          title: Text("設定"),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.format_size),
              title: Slider(
                  value: vm.state.fontSize,
                  min: 10,
                  max: 64,
                  divisions: (64 - 10),
                  onChanged: vm.onChanged),
              subtitle: Text(
                '字型大小:${vm.state.fontSize}',
                style: TextStyle(fontSize: vm.state.fontSize),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(
                '特色',
                style: TextStyle(fontSize: fontSizeNorm),
              ),
              subtitle: Text(
                '離線瀏覽、書籤功能、字型調整。',
                style: TextStyle(fontSize: fontSizeNorm),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                '關於',
                style: TextStyle(fontSize: fontSizeNorm),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '程式版本: 1.0.0',
                      style: TextStyle(fontSize: fontSizeNorm),
                    ),
                    Text(
                      'CBETA API版: ${apiVersion}',
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
                            launch('mailto:myh@live.com');
                          },
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '開放原始碼(含說明)',
                        style: TextStyle(
                            color: Colors.blue, fontSize: fontSizeNorm),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://github.com/MrMYHuang/cbetar');
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
                            launch('http://cbdata.dila.edu.tw/v1.2/');
                          },
                      ),
                    )
                  ]),
            ),
          ],
        ),
      );
    });
  }
}

class _SettingScreenViewModel {
  final AppState state;
  final void Function(double value) onChanged;

  _SettingScreenViewModel({this.state, this.onChanged});
}
