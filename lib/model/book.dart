import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Book {
  String? id;
  String? title;
  String? mainTitle;
  String? cover;
  String? readingStatus;
  int? iSBN;
  String? synopsis;

  Book(
      {this.id,
      this.title,
      this.mainTitle,
      this.cover,
      this.readingStatus,
      this.iSBN});

  Book.fromJson(Map<String, dynamic> json, context) {
    id = json['id'];
    title = json['title'];
    mainTitle = json['main_title'];
    cover = json['cover'];
    readingStatus = json['is_read'] == 0
        ? ""
        : AppLocalizations.of(context)!.currentlyReading;
    iSBN = json['ISBN'];
    synopsis = json['synopsis'];
  }

  Map<String, dynamic> toJson(context) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['main_title'] = this.mainTitle;
    data['cover'] = this.cover;
    data['is_read'] =
        this.readingStatus == AppLocalizations.of(context)!.currentlyReading
            ? 1
            : 0;
    data['ISBN'] = this.iSBN;
    return data;
  }
}
