import 'package:flutter/material.dart';
import 'manga_search_delegate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MySearchPage extends StatefulWidget {
  final List<String> titles;

  const MySearchPage({super.key, required this.titles});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<String> filteredTitles = []; // Liste pour les titres filtrés
  TextEditingController searchController = TextEditingController(); // Contrôleur pour la recherche

  @override
  void initState() {
    super.initState();
    filteredTitles = widget.titles; // Initialiser avec la liste complète
  }

  // Filtrer les titres en fonction de la recherche
  void _filterTitles(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTitles = widget.titles; // Afficher tous les titres si la recherche est vide
      } else {
        filteredTitles = widget.titles
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
                labelText: AppLocalizations.of(context)!.searchManga,
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
                  onTap: () {
                    // Action lors du clic sur un titre (par exemple, afficher plus de détails)

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
