import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
