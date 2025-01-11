class Tome {
  String? tomeName;
  String? cover;
  String? isbn10;
  String? isbn13;
  String? seriesName;
  String? synopsis;
  int? key;

  Tome({
    this.tomeName,
    this.cover,
    this.isbn10,
    this.isbn13,
    this.seriesName,
    this.synopsis,
    this.key
  });

  int? extractVolumeNumber(String text) {
    final regex = RegExp(r'Vol(\d+)'); // Cherche "Vol" suivi d'un ou plusieurs chiffres
    final match = regex.firstMatch(text);

    if (match != null) {
      return int.tryParse(match.group(1)!); // Récupère le premier groupe capturé (le numéro)
    }
    return null; // Retourne null si aucun match trouvé
  }

  Tome.fromJson(Map<String, dynamic> json, String seriesTitle, String keys) {
    key = extractVolumeNumber(keys);
    tomeName = json['name'];
    cover = json['cover'];
    isbn10 = json['isbn_10'];
    isbn13 = json['isbn_13'];
    seriesName = seriesTitle;
    synopsis = json['synopsis'];
  }
}