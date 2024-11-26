class Book {
  String? id;
  String? title;
  String? mainTitle;
  String? cover;
  String? readingStatus;
  int? iSBN;

  Book(
      {this.id,
        this.title,
        this.mainTitle,
        this.cover,
        this.readingStatus,
        this.iSBN});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mainTitle = json['main_title'];
    cover = json['cover'];
    readingStatus = json['is_read'] == 0 ? "" : "Lecture en cours" ;
    iSBN = json['ISBN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['main_title'] = this.mainTitle;
    data['cover'] = this.cover;
    data['is_read'] = this.readingStatus == "Lecture en cours" ? 1 : 0;
    data['ISBN'] = this.iSBN;
    return data;
  }
}