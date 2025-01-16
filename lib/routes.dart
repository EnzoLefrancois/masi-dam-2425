import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/main.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/screen/login/login.dart';
import 'package:manga_library/screen/options.dart';
import 'package:manga_library/screen/login/register_form.dart';
import 'package:manga_library/screen/login/reset_password_form.dart';
import 'package:manga_library/screen/options_reset_password_form.dart';
import 'package:manga_library/screen/series_details_page.dart';
import 'package:manga_library/screen/tome_detail_page.dart';

import 'screen/isbn_scanner.dart';

var customRoutes = <String, WidgetBuilder>{
  '/': (context) => FirebaseAuth.instance.currentUser == null ? LoginForm() : const MyHomePage(title: "Manga Vault") ,

  '/isbn-scanner': (context) => FirebaseAuth.instance.currentUser == null ? LoginForm() : const IsbnScannerScreen(),

  '/series-details': (context) {
    if (FirebaseAuth.instance.currentUser == null)
    {
      return LoginForm();
    }
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Serie serie = args['serie'] as Serie;
    List<OwnedTome> ownedTomes = args['ownedTomes'] as List<OwnedTome>;
    return SeriesDetailsPage(
        series: serie,
        ownedTome: ownedTomes
    );
  },
  '/tome-details': (context) {
    if (FirebaseAuth.instance.currentUser == null)
    {
      return LoginForm();
    }
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final tome = arguments['tome'] as Tome;
    final serie = arguments['serie'] as Serie;
    List<OwnedTome> ownedTomes = arguments['ownedTomes'] as List<OwnedTome>;
    return TomeDetailPage(
      tome: tome,
      serie: serie,
      ownedTome : ownedTomes
    );
  },
  '/login': (context) => FirebaseAuth.instance.currentUser == null ? LoginForm() : const MyHomePage(title: "Manga Vault"),
  '/register': (context) => FirebaseAuth.instance.currentUser == null ? RegisterForm() : const MyHomePage(title: "Manga Vault"),
  '/resetPassword': (context) => FirebaseAuth.instance.currentUser == null ? ResetPasswordForm() : const MyHomePage(title: "Manga Vault"),
  '/change-password': (context) => FirebaseAuth.instance.currentUser == null ? LoginForm() : const ChangePasswordPage(),

};