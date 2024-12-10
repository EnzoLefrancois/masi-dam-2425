import 'package:manga_library/model/authors.dart';
import 'package:manga_library/model/book.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Series {
  String? title;
  String? cover;
  String? readingStatus;
  int? nbBooks;

  int nbOwnedBook = 0;

  List<String>? genresList;
  List<Authors>? authorsList;

  List<Book> books = [];

  Series(
      {this.title,
      this.cover,
      this.readingStatus,
      this.nbBooks,
      this.genresList,
      this.authorsList});

  void addBook(Book book) => books.add(book);

  Series.fromJson(Map<String, dynamic> json, context) {
    title = json['title'];
    cover = json['cover'];
    readingStatus = json['is_read'] == 0
        ? ""
        : AppLocalizations.of(context)!.currentlyReading;
    nbBooks = json['nbBooks'];
    nbOwnedBook = json['nbOwnedBook'];
  }

  Map<String, dynamic> toJson(context) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['is_read'] =
        this.readingStatus == AppLocalizations.of(context)!.currentlyReading
            ? 1
            : 0;
    data['nbBooks'] = this.nbBooks;
    data['nbOwnedBook'] = this.nbOwnedBook;
    return data;
  }
}
