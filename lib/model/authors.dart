class Authors {
  final int id;
  final String firstName;
  final String lastName;
  final String role;

  // Constructeur
  Authors({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  // Méthode pour afficher le nom complet
  String get fullName => "$firstName $lastName".trim();

  // Méthode pour créer une instance à partir d'un JSON
  factory Authors.fromJson(Map<String, dynamic> json) {
    return Authors(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      role: json['role'] as String,
    );
  }

  // Méthode pour convertir une instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    };
  }

  @override
  String toString() {
    return "$fullName ($role)";
  }
}
