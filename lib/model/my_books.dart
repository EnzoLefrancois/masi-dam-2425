import 'book.dart';

class MyBooks {
  List<Book>? books;

  MyBooks({this.books});

  MyBooks.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <Book>[];
      json['books'].forEach((v) {
        books!.add(new Book.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
