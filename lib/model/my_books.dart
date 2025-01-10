import 'package:manga_library/model/tome.dart';

class OwnedTome {
  String? isbn10;
  int? readingStatus;
  int? serieId;

  OwnedTome({this.isbn10, this.readingStatus, this.serieId});

  OwnedTome.fromJson(Map<String, dynamic> json) {
    isbn10 = json['isbn_10'];
    readingStatus = json['reading_status'];
    serieId = json['series_id'];
  }
}

class MyBooks {
  List<OwnedTome>? books = [];

  MyBooks({this.books});

  MyBooks.fromJson(Map<String, dynamic> json) {
    books = <OwnedTome>[];
    json.forEach((key, value) {
      books!.add(OwnedTome.fromJson(value));
    });
  }
}
