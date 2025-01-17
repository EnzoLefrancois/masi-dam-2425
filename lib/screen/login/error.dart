import 'package:flutter/material.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text("Nous avons un problème de connexion", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),))),
    );
  }
}
