import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'list.dart';

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
  int _selectedIndex = 1; // Variable pour gérer l'index de la page sélectionnée
  final PageController _pageController = PageController(); // Pour la gestion du swipe
  List<String> mangaTitles = []; // Liste pour stocker les titres des mangas

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

    // Trouver l'index de la colonne "title"
    final titleIndex = list[0].indexOf('title');

    // Extraire les titres des mangas à partir de la colonne "title"
    setState(() {
      mangaTitles = list
          .skip(1) // On saute la première ligne (en-têtes)
          .map((row) => row[titleIndex].toString()) // Convertit chaque valeur en chaîne
          .toList();
    });

    // Mettre à jour les pages après avoir chargé les titres
    _pages.addAll([
      const Center(child: Text("Page 1", style: TextStyle(fontSize: 30))),
      const Center(child: Text("Page 2", style: TextStyle(fontSize: 30))),
      MySearchPage(titles: mangaTitles,), // Passer la liste des titres à MySearchPage
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
