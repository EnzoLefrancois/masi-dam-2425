import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key, required this.title});

  final String title;

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Key Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter API Key Example'),
        ),
        body: Center(
          child: Text(dotenv.env['API_KEY'] ?? 'No API Key Found'),
        ),
      ),
    );

  }

}
