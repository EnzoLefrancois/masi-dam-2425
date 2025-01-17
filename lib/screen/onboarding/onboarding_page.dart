import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:manga_library/screen/onboarding/onboaring_creator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
    Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 26, 33, 41),
              Color.fromARGB(255, 64, 74, 96),
            ],
          ),
        ),

        child: IntroductionScreen(
            scrollPhysics: const BouncingScrollPhysics(),
            pages: [
              OnboardingPageCreator.onboardingCreate(context,
                  'Manga Vault',
                  AppLocalizations.of(context)!.onboardingPageSubtitle1,
                  'assets/images/splash.png',2.5),
              OnboardingPageCreator.onboardingCreate(context,
                  AppLocalizations.of(context)!.onboardingPageTitle2,
                  AppLocalizations.of(context)!.onboardingPageSubtitle2,
                  'assets/images/scan_isbn.gif',2),
              OnboardingPageCreator.onboardingCreate(context,
                  AppLocalizations.of(context)!.onboardingPageTitle3,
                  AppLocalizations.of(context)!.onboardingPageSubtitle3,
                  'assets/images/wishlist.gif',2),
              OnboardingPageCreator.onboardingCreate(context,
                  AppLocalizations.of(context)!.onboardingPageTitle4,
                  AppLocalizations.of(context)!.onboardingPageSubtitle4,
                  'assets/images/owned_manga.gif',2),
              OnboardingPageCreator.onboardingCreate(context,
                  AppLocalizations.of(context)!.onboardingPageTitle5,
                  AppLocalizations.of(context)!.onboardingPageSubtitle5,
                  'assets/images/search.gif',2),
              OnboardingPageCreator.onboardingCreate(context,
                  AppLocalizations.of(context)!.onboardingPageTitle6,
                  AppLocalizations.of(context)!.onboardingPageSubtitle6,
                  'assets/images/read.gif',2),

            ],
            onDone: () async {
              goToHome(context);
            },
            back: const Icon(Icons.arrow_back),
            next: const Icon(Icons.forward),
            done: Text(
                AppLocalizations.of(context)!.onboardingPageFinishButton,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            dotsDecorator: getDotDecorator(),
          ),
        ),
      
    );
  }

  DotsDecorator getDotDecorator() {
    return DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(30.0, 10.0),
              activeColor: Colors.deepPurple,
              color: Colors.black45,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
              ),
            );
  }

  Future<void> goToHome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    if (context.mounted) {
      Navigator.of(context).popAndPushNamed('/'); // Naviguer vers la page d'accueil
    }
  }

  PageDecoration getPageDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 16.0),
        imagePadding: EdgeInsets.all(20),
        pageColor: Colors.white,
      );

}
