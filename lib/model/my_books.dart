
class OwnedTome {
  String? isbn;
  int? readingStatus;
  int? serieId;

  OwnedTome({this.isbn, this.readingStatus, this.serieId});

  OwnedTome.fromJson(Map<String, dynamic> json) {
    isbn = json['isbn'];
    readingStatus = json['reading_status'];
    serieId = json['series_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'isbn': isbn,
      'series_id': serieId,
      'reading_status': readingStatus,
    };
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
