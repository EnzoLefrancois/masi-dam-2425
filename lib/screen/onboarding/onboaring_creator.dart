import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingPageCreator {
  static PageViewModel onboardingCreate(context, String title, String description, String imagePath, double imageHeight) {
    double height = MediaQuery.of(context).size.height;
    return PageViewModel(
      titleWidget: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24),
      ),
      reverse: false,
      bodyWidget: Center(
          child: Column(
        children: [
          SizedBox(
            height: height / 35,
          ),
          SizedBox(
            height: height / imageHeight,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  imagePath,
                )),
          ),
          SizedBox(
            height: height / 15,
          ),
          Center(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
            ),
          ),
        ],
      )),
      decoration: const PageDecoration(),
    );
  }
}
