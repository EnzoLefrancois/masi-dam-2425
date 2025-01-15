import 'package:manga_library/provider/language_provider.dart';
import 'package:manga_library/provider/theme_provider.dart';
import 'package:manga_library/provider/user_provider.dart';
import 'package:manga_library/screen/login/login.dart';
import 'package:manga_library/main.dart';
import 'package:manga_library/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/service/shared_pref_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  user!.image!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            '${user.firstName!} - ${user.lastName!}',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
          ),
          Text(
            user.email!,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          _parameterBuilder(context),
          const SizedBox(
            height: 24,
          ),
          _aboutBuilder(context),
          const SizedBox(
            height: 24,
          ),
          _logoutButtonBuilder(context),
        ],
      ),
    );
  }

  Widget _logoutButtonBuilder(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                      child: Text(
                          AppLocalizations.of(context)!.optionPageLogoutConfirm),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            removeUserFromPreference();
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/login');
                          },
                          child:  Text(AppLocalizations.of(context)!.optionPageLogoutConfirmYes)),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:  Text(AppLocalizations.of(context)!.optionPageLogoutConfirmNo))
                  ],
                )
              ],
            );
          },
        );
      },
      label: Text(
        AppLocalizations.of(context)!.optionPageLogoutText,
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      icon:const Icon(
        Icons.logout,
        size: 18,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        iconColor: Theme.of(context).primaryColor,
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _aboutBuilder(BuildContext context) {
    return Material(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.optionPageAboutTitle,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 16,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.optionPageVersion),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Chargement...');
                          }
                          if (snapshot.hasError) {
                            return const Text('Erreur de chargement');
                          }
                          final packageInfo = snapshot.data!;
                          return Text(
                              packageInfo.version);
                        },
                      ),
                    ])
              ],
            )));
  }

  Widget _parameterBuilder(BuildContext context) {
    final  languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.optionPageSettingTitle,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.language,
                          size: 24,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.optionPageLanguageTitle,
                        ),
                      ],
                    ),
                     DropdownButton<String>(
                      value: languageProvider.locale.languageCode,
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(AppLocalizations.of(context)!.optionPageLanguageEnglish),
                        ),
                        DropdownMenuItem(
                          value: 'fr',
                          child: Text(AppLocalizations.of(context)!.optionPageLanguageFrench),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          languageProvider.changeLanguage(value);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.dark_mode,
                          size: 24,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.optionPageThemeSelect,
                        ),
                      ],
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/change-password');
                  },
                  label: Text(
                    AppLocalizations.of(context)!.optionPageChangePassword,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  icon: const Icon(
                    Icons.lock_outline,
                    size: 15,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    iconColor: Colors.black,
                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
