import 'package:manga_library/model/tome.dart';

class Serie {
  String? name;
  String? mainCover;
  String? author;
  int? nbVolume;
  int? serieId;
  List<String>? categories = [];
  List<Tome>? tomes = [];

  int nbOwnedTomes = 0;
  int reading_status = 0;

  Serie(
      {this.name,
      this.author,
      this.categories,
      this.tomes,
      this.serieId,
      this.mainCover,
      this.nbVolume});

  Serie.fromJson(Map<String, dynamic> json, String serieName) {
    name = serieName;
    mainCover = json['main_cover'];
    author = json['author'];
    nbVolume = json['nb_volume'];
    serieId = json['series_id'];
    categories = List<String>.from(json['categories']);
  }

  void addTome(Tome tome) => tomes!.add(tome);
}
