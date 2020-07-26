import 'package:flutter/material.dart';

import 'SearchScreen.dart';
import 'Utilities.dart';

double fontSizeNorm = 24;
double fontSizeLarge = 48;
String apiVersion = 'v1.2';
String cbetaApiUrl = 'http://cbdata.dila.edu.tw/${apiVersion}';

void searchCbeta(BuildContext context) async {
  final searchText = await asyncInputDialog(context, '搜尋經文', '輸入搜尋', '例:金剛經');

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
