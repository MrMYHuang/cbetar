import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'Globals.dart';

class Model {
  Model(Map<String, dynamic> json);
}

Future<List<Object>> fetchData(http.Client client, String url) async {
  final response = await client.get(url);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseData, response.body);
}

List<Object> parseData(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<String, dynamic>();
  return parsed["results"] as List<dynamic>;
}

Future<File> getLocalFile(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/${fileName}');
}

Future<bool> saveFile(String fileName, String text) async {
  final file = await getLocalFile(fileName);
  file.writeAsStringSync(text);
  return true;
}

Future<String> loadLocalFile(String fileName) async {
  final file = await getLocalFile(fileName);
  return file.readAsStringSync();
}

Future<String> asyncInputDialog(BuildContext context, String message, String field, String hint) async {
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
          FlatButton(
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

Future<bool> asyncYesNoDialog(BuildContext context, String title, String content) async {
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
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
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
