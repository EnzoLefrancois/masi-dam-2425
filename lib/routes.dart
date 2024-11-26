import 'package:flutter/material.dart';
import 'package:manga_library/main.dart';

import 'screen/isbn_scanner.dart';

var customRoutes = <String, WidgetBuilder>{
  '/': (context) => const MyHomePage(title: "Manga Vault"),

  '/isbn-scanner': (context) => const IsbnScannerScreen(),
};