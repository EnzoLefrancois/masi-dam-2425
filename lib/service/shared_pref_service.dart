import 'package:flutter/material.dart';
import 'package:manga_library/model/user_model.dart';
import 'package:manga_library/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeUserFromPreference() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('firstName');
  prefs.remove('lastName');
  prefs.remove('email');
  prefs.remove('image');
  prefs.remove('id');
}

Future<void> saveUserToPreferences(UserModel user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('firstName', user.firstName!);
  prefs.setString('lastName', user.lastName!);
  prefs.setString('email', user.email!);
  prefs.setString('image', user.image!);
  prefs.setString('id', user.id!);
}

Future<void> loadUserFromPreferences(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  final firstName = prefs.getString('firstName');
  final lastName = prefs.getString('lastName');
  final email = prefs.getString('email');
  final image = prefs.getString('image');
  final id = prefs.getString('id');

  if (firstName != null && lastName != null && email != null && image != null && id != null) {
    final user = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      image: image,
      id: id
    );
    if (context.mounted) {
      Provider.of<UserProvider>(context, listen: false).setUser(user);
    }
  }
}

