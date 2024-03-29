import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:charset_converter/charset_converter.dart';

import 'Globals.dart';

class Model {
  Model(Map<String, dynamic>? json);
}

Future<List<dynamic>> fetchData(http.Client client, String url) async {
  final response = await client.get(Uri.parse(url));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseData, response.body);
}

Future<Uint8List> downloadFile(http.Client client, String url) async {
  var res = await client.get(Uri.parse(url));
  return res.bodyBytes;
}

Future<String> htmlBig5ToUtf8(Uint8List data) async {
  String decoded = await CharsetConverter.decode("Big5", data);
  return decoded.replaceFirst("charset=big5", "charset=utf8");
}

List<dynamic> parseData(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<String, dynamic>();
  return parsed["results"] as List<dynamic>;
}

Future<File> getLocalFile(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$fileName');
}

Future<bool> saveFile(String fileName, String text) async {
  final file = await getLocalFile(fileName);
  file.writeAsStringSync(text);
  return true;
}

Future<bool> delFile(String fileName) async {
  final file = await getLocalFile(fileName);
  try {
    file.deleteSync();
    return true;
  } catch (e) {
    return false;
  }
}

Future<String> loadLocalFile(String fileName) async {
  final file = await getLocalFile(fileName);
  return file.readAsStringSync();
}

Future<String?> asyncInputDialog(BuildContext context, String message, String field, String hint) async {
  String text = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: true, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: field, labelStyle: TextStyle(fontSize: fontSizeNorm), hintText: hint),
                  onChanged: (value) {
                    text = value;
                  },
                ))
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('確定'),
            onPressed: () {
              Navigator.of(context).pop(text);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> asyncYesNoDialog(BuildContext context, String title, String content) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: new Row(
          children: <Widget>[
            Text(content)
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('確定'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> asyncYesDialog(BuildContext context, String title, String content) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: new Row(
          children: <Widget>[
            Flexible(child: Text(content),)
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('確定'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
