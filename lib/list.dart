import 'package:flutter/material.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/service/firestore_service.dart';

class MySearchPage extends StatefulWidget {
  final List<Serie> allSeries;

  const MySearchPage({super.key, required this.allSeries});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<String> allTitles = [];
  List<String> filteredTitles = []; // Liste pour les titres filtrés
  TextEditingController searchController = TextEditingController(); // Contrôleur pour la recherche

  @override
  void initState() {
    allTitles = widget.allSeries.map((row) => row.name!).toList();

    super.initState();
    filteredTitles = allTitles; // Initialiser avec la liste complète
  }

  // Filtrer les titres en fonction de la recherche
  void _filterTitles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTitles = allTitles; // Afficher tous les titres si la recherche est vide
      } else {
        filteredTitles = allTitles
            .where((title) => title.toLowerCase().contains(query.toLowerCase())) // Filtrer en fonction de la recherche
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "chercher",
                border: const OutlineInputBorder(),
              ),
              onChanged: _filterTitles, // Filtrer les titres lors de la saisie
            ),
          ),
          // Afficher la liste filtrée
          Expanded(
            child: ListView.builder(
              itemCount: filteredTitles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredTitles[index]),
                  onTap: () async {
                    // Action lors du clic sur un titre (par exemple, afficher plus de détails)
                    Serie s = widget.allSeries.firstWhere((serie) => serie.name! == filteredTitles[index]);
                    MyBooks myBooks = await getUsersAllOwnedBooks();
                    Navigator.pushNamed(context, '/series-details', arguments: {
                      "serie" : s,
                      "ownedTomes" : myBooks.books!
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
