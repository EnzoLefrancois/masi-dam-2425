class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? id;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.id
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    image = json['photoUrl'];
    id = json['uid'];
  }
}
