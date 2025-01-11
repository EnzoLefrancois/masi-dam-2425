class Tome {
  String? tomeName;
  String? cover;
  String? isbn10;
  String? isbn13;
  String? seriesName;

  Tome({
    this.tomeName,
    this.cover,
    this.isbn10,
    this.isbn13,
    this.seriesName,
  });

  Tome.fromJson(Map<String, dynamic> json, String seriesTitle) {
    tomeName = json['name'];
    cover = json['cover'];
    isbn10 = json['isbn_10'];
    isbn13 = json['isbn_13'];
    seriesName = seriesTitle;
  }
}