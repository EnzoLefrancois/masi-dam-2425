import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguageFromPreferences(); // Charger la langue au démarrage
  }

  void changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    await _saveLanguageToPreferences(languageCode); // Sauvegarder la nouvelle langue

  }
  
  Future<void> _loadLanguageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('languageCode') ?? 'en'; // Langue par défaut : anglais
    _locale = Locale(savedLanguageCode);
    notifyListeners();
  }

  Future<void> _saveLanguageToPreferences(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}
