class MyBooks {
  List<Books>? books;

  MyBooks({this.books});

  MyBooks.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
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

class Books {
  String? id;
  String? title;
  String? mainTitle;
  String? cover;
  String? readingStatus;
  int? iSBN;

  Books(
      {this.id,
        this.title,
        this.mainTitle,
        this.cover,
        this.readingStatus,
        this.iSBN});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mainTitle = json['main_title'];
    cover = json['cover'];
    readingStatus = json['is_read'] == 0 ? "" : "  -  Lecture en cours" ;
    iSBN = json['ISBN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['main_title'] = this.mainTitle;
    data['cover'] = this.cover;
    data['is_read'] = this.readingStatus == "  -  Lecture en cours" ? 1 : 0;
    data['ISBN'] = this.iSBN;
    return data;
  }
}

class LibraryBook {
  String? title;
  String? cover;
  String? readingStatus;
  int? nbBooks;

  int nbOwnedBook = 0;

  LibraryBook({
    this.title,
    this.cover,
    this.readingStatus,
    this.nbBooks,
  });

  LibraryBook.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    cover = json['cover'];
    readingStatus = json['is_read'] == 0 ? "" : "  -  Lecture en cours" ;
    nbBooks = json['nbBooks'];
    nbOwnedBook = json['nbOwnedBook'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['is_read'] = this.readingStatus == "  -  Lecture en cours" ? 1 : 0;
    data['nbBooks'] = this.nbBooks;
    data['nbOwnedBook'] = this.nbOwnedBook;
    return data;
  }
}
