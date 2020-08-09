import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'SearchScreen.dart';
import 'Utilities.dart';

double fontSizeNorm = 24;
double fontSizeLarge = 48;
String apiVersion = 'v1.2';
String cbetaApiUrl = 'http://cbdata.dila.edu.tw/${apiVersion}';

Map<String, String> mainCatalogs = {
  "CBETA": "CBETA 部類",
  "others": "歷代藏經補輯",
  "modern": "近代新編文獻",
  "Cat-T": "大正藏(部別)",
  "Cat-X": "卍續藏(部別)",
  "Cat-N": "南傳大藏經(部別)",
  "Vol-A": "趙城金藏",
  "Vol-B": "大藏經補編",
  "Vol-C": "中華大藏經-中華書局版",
  "Vol-D": "國圖善本",
  "Vol-F": "房山石經",
  "Vol-G": "佛教大藏經",
  "Vol-GA": "中國佛寺史志彙刊",
  "Vol-GB": "中國佛寺志叢刊",
  "Vol-I": "北朝佛教石刻拓片百品",
  "Vol-J": "嘉興藏",
  "Vol-K": "高麗大藏經-新文豐版",
  "Vol-L": "乾隆大藏經-新文豐版",
  "Vol-LC": "呂澂佛學著作集",
  "Vol-M": "卍正藏經-新文豐版",
  "Vol-N": "南傳大藏經(冊別)",
  "Vol-P": "永樂北藏",
  "Vol-S": "宋藏遺珍-新文豐版",
  "Vol-T": "大正藏(冊別)",
  "Vol-U": "洪武南藏",
  "Vol-X": "卍續藏(冊別)",
  "Vol-ZS": "正史佛教資料類編",
  "Vol-ZW": "藏外佛教文獻",
  "Vol-Y": "印順法師佛學著作集",
};

http.Client httpClient;

void searchCbeta(BuildContext context) async {
  final searchText = await asyncInputDialog(context, '搜尋經文', '輸入搜尋', '例:金剛般若');

  if (searchText == null || searchText == '') {
    return;
  }

  Navigator.push(
      context,
      PageRouteBuilder(
      pageBuilder:
      (context, animation1, animation2) =>
      SearchScreen(keyword: searchText))
  );
}
