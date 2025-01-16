import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:manga_library/screen/onboarding/onboaring_creator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
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
            // globalBackgroundColor: Colors.transparent,
            scrollPhysics: const BouncingScrollPhysics(),
            pages: [
              OnboardingPageCreator.onboardingCreate(context,'Manga Vault',"L'application pour suivre l'évolution de votre mangathèque", 'assets/images/splash.png',2.5),
              OnboardingPageCreator.onboardingCreate(context,'Ajouter un/des mangas',"Cliquer sur le bouton flottant et scanner le code barre de vos mangas", 'assets/images/wishlist.png',2),
              OnboardingPageCreator.onboardingCreate(context,'Ajouter les wishlist de vos collègues',"Scanner le QR code de votre amis, et celle-ci serai ajoutée", 'assets/images/wishlist.png',2),
              OnboardingPageCreator.onboardingCreate(context,'Visualiser vos mangas',"Visualiser les mangas que vous possèdez - Faites une recherche sur les mangas que vous possèder", 'assets/images/wishlist.png',2),
              OnboardingPageCreator.onboardingCreate(context,'Chercher un manga particulier', 'Faites une recherche sur le manga que vous chercher, ajouter le a votre wishlist ou bien ajouter le a votre collection', 'assets/images/wishlist.png',2),
              OnboardingPageCreator.onboardingCreate(context, 'Lectre en cours', 'Vous êtes en phase de lecture d\'un manga ? Indiquez le grâce au bouton PLAY\n Profitez de l\'application', 'assets/images/wishlist.png',2),

            ],
            onDone: () async {
              goToHome(context);
            },
            // onSkip: () async {
            //   goToHome(context);
            // },
            // showSkipButton: true,
            // skip: Text("Skip"),
            back: const Icon(Icons.arrow_back),
            next: const Icon(Icons.forward),
            done: Text("Terminer", style: const TextStyle(fontWeight: FontWeight.w600)),
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
    Navigator.of(context).popAndPushNamed('/'); // Naviguer vers la page d'accueil
  }

  PageDecoration getPageDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 16.0),
        imagePadding: EdgeInsets.all(20),
        pageColor: Colors.white,
      );

}
