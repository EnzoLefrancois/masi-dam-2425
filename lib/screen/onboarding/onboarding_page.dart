import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: '  ',
              bodyWidget: Column(
                children: [
                  Text(
                    "Bienvenue dans l'application",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Découvrez toutes nos fonctionnalités et simplifiez votre quotidien.",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                ],
              ),
              image: Center(child: Image.asset('assets/images/detail-tome.gif', height: MediaQuery.of(context).size.height,)),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "Gérez vos tâches",
              body: "Organisez vos priorités en un seul endroit.",
              image: Center(child: Image.asset('assets/images/splash.png', height: 175.0)),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "Restez connectés",
              body: "Partagez vos progrès avec vos amis et collègues.",
              image: Center(child: Image.asset('assets/images/detail-tome.gif', )),
              decoration: getPageDecoration(),
            ),
          ],
          onDone: () => goToHome(context),
          // onSkip: () => goToHome(context), // Skip button action
          // showSkipButton: true,
          // skip: const Text("Passer"),
          next: const Icon(Icons.arrow_forward),
          done: const Text("Commencer", style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: getDotsDecorator(),
        ),
      ),
    );
  }

  Future<void> goToHome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Navigator.of(context).popAndPushNamed('/'); // Naviguer vers la page d'accueil
  }

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 16.0),
        imagePadding: EdgeInsets.all(20),
        pageColor: Colors.white,
      );

  DotsDecorator getDotsDecorator() => DotsDecorator(
        color: Colors.grey,
        activeColor: Colors.blue,
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      );
}
