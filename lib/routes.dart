import 'package:flutter/material.dart';
import 'package:manga_library/main.dart';
import 'package:manga_library/model/series.dart';
import 'package:manga_library/screen/series_details_page.dart';

import 'screen/isbn_scanner.dart';

var customRoutes = <String, WidgetBuilder>{
  '/': (context) => const MyHomePage(title: "Manga Vault"),

  '/isbn-scanner': (context) => const IsbnScannerScreen(),

  '/series-details' : (context) {
    final series = ModalRoute.of(context)?.settings.arguments as Series;
    return SeriesDetailsPage(series: series);
  }
};