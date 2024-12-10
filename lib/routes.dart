import 'package:flutter/material.dart';
import 'package:manga_library/main.dart';

import 'screen/isbn_scanner.dart';

var customRoutes = <String, WidgetBuilder>{
  '/': (context) => const MyHomePage(),

  '/isbn-scanner': (context) => const IsbnScannerScreen(),
};