import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:manga_library/screen/MyLibraryPage.dart';
import 'list.dart';
import 'model/mybooks.dart';

Future<void> main() async {
  // Charger le fichier .env
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Manga Vault'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Variable pour gérer l'index de la page sélectionnée
  final PageController _pageController = PageController(); // Pour la gestion du swipe
  List<String> mangaTitles = []; // Liste pour stocker les titres des mangas
  List<LibraryBook> allMangaLibrary = [];

  // Liste des pages de l'application
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    loadCSV(); // Charger le fichier CSV au démarrage
  }

  // Charger et parser le fichier CSV
  Future<void> loadCSV() async {
    // Charger le fichier manga.csv depuis les assets
    final rawData = await rootBundle.loadString('assets/manga.csv');

    // Parser le CSV
    List<List<dynamic>> list = CsvToListConverter().convert(rawData);

    // Trouver l'index des colonnes "title" et "type"
    final titleIndex = list[0].indexOf('title');
    final typeIndex = list[0].indexOf('type');

    final coverIndex = list[0].indexOf('main_picture');
    final volumeIndex = list[0].indexOf('volumes');

    // Extraire les titres des mangas dont le type est "manga"
    setState(() {
      mangaTitles = list
          .skip(1) // On saute la première ligne (en-têtes)
          .where((row) => row[typeIndex] == 'manga') // Filtrer les lignes où "type" est égal à "manga"
          .map((row) => row[titleIndex].toString()) // Convertir chaque titre en chaîne
          .toList();
      allMangaLibrary = list
          .skip(1) // On saute la première ligne (en-têtes)
          .where((row) => row[typeIndex] == 'manga') // Filtrer les lignes où "type" est égal à "manga"
          .map((row)  {

            return LibraryBook(
                title:  row[titleIndex].toString().trim().isEmpty ? "" : row[titleIndex].toString().trim(),
                cover:  row[coverIndex].toString(),
                nbBooks: int.tryParse(row[volumeIndex].toString().trim().isEmpty ? "0" : row[volumeIndex].toString().trim()) ?? 0 );
      } )
          .toList();
    });



  // Mettre à jour les pages après avoir chargé les titres
    _pages.addAll([
      const Center(child: Text("Page 1", style: TextStyle(fontSize: 30))),
      MyLibrarypage(allBooks: allMangaLibrary,),
      MySearchPage(titles: mangaTitles, ), // Passer la liste des titres à MySearchPage
      const Center(child: Text("Page 4", style: TextStyle(fontSize: 30))),
    ]);
  }

  // Fonction pour changer la page via le BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Synchroniser avec le swipe
  }

  // Fonction pour naviguer en swipe
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Chargement initial
          : PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged, // Gérer le swipe
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Changer de page via le menu
        selectedItemColor: Colors.blue, // Couleur des icônes sélectionnées
        unselectedItemColor: Colors.grey, // Couleur des icônes non sélectionnées
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bibliothèque',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Options',
          ),
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.document_scanner_rounded),
      ),
    );
  }
}
