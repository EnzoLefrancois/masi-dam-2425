import 'package:flutter/material.dart';

class MySearchPage extends StatelessWidget {
  final List<String> titles; // Recevoir la liste des titres

  const MySearchPage({super.key, required this.titles, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Manga"),
      ),
      body: titles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(titles[index]),
            onTap: () {
              // Action lors du clic sur un titre (par exemple, afficher plus de détails)
            },
          );
        },
      ),
    );
  }
}
