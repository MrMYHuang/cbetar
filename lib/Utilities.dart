import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
