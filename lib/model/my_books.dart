import 'book.dart';

class MyBooks {
  List<Book>? books;

  MyBooks({this.books});

  MyBooks.fromJson(Map<String, dynamic> json, context) {
    if (json['books'] != null) {
      books = <Book>[];
      json['books'].forEach((v) {
        books!.add(Book.fromJson(v, context));
      });
    }
  }

  Map<String, dynamic> toJson(context) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (books != null) {
      data['books'] = books!.map((v) => v.toJson(context)).toList();
    }
    return data;
  }
}
