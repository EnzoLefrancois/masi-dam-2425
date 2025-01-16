import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  List<Locale> get localList => [const Locale('en', 'US'), const Locale('fr', 'FR')];

  LanguageProvider() {
    _loadLanguageFromPreferences(); // Charger la langue au démarrage
  }

  void changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    await _saveLanguageToPreferences(languageCode); // Sauvegarder la nouvelle langue

  }
  
  Future<void> _loadLanguageFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('languageCode');
    if (savedLanguageCode !=null) {
      _locale = localList.firstWhere((local) => local.languageCode == savedLanguageCode);
    } else {
      final List<Locale> systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
      Locale selectedLanguage = const Locale('fr', 'FR'); // Par défaut au français
      for (final Locale locale in systemLocales) {
        if (localList.contains(locale)) {
          selectedLanguage = locale;
          break;
        }
      }
      await prefs.setString('selectedLanguage', selectedLanguage.languageCode);
      _locale = selectedLanguage;
    }

    notifyListeners();
  }

  Future<void> _saveLanguageToPreferences(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}
