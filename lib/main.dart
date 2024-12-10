import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manga_library/screen/MyLibraryPage.dart';
import 'list.dart';
import 'model/series.dart';
import './routes.dart';

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
      title: 'Manga Vault',

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // Spanish
      ],

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),

      routes: customRoutes,
      initialRoute: '/',

      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Variable pour gérer l'index de la page sélectionnée
  final PageController _pageController = PageController(); // Pour la gestion du swipe
  List<String> mangaTitles = []; // Liste pour stocker les titres des mangas
  List<Series> allMangaLibrary = [];

  // Liste des pages de l'application
  final List<Widget> _pages = [];

  bool _areTitleLoaded = false;
  List<String> _pageTitles = [];

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

            return Series(
                title:  row[titleIndex].toString().trim().isEmpty ? "" : row[titleIndex].toString().trim(),
                cover:  row[coverIndex].toString(),
                nbBooks: int.tryParse(row[volumeIndex].toString().trim().isEmpty ? "0" : row[volumeIndex].toString().trim()) ?? 0 );
      } )
          .toList();
    });

    // Mettre à jour les pages après avoir chargé les titres
    _pages.addAll([
      const Center(child: Text("TODO : WISHLIST", style: TextStyle(fontSize: 30))),
      MyLibrarypage(allBooks: allMangaLibrary),
      MySearchPage(titles: mangaTitles), // Passer la liste des titres à MySearchPage
      const Center(child: Text("TODO : PROFILE", style: TextStyle(fontSize: 30))),
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
    if(!_areTitleLoaded) {
      _pageTitles = [
        AppLocalizations.of(context)!.wishlist,
        AppLocalizations.of(context)!.library,
        AppLocalizations.of(context)!.search,
        AppLocalizations.of(context)!.profile,
      ];
      _areTitleLoaded = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(_pageTitles[_selectedIndex]),
      ),
      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: AppLocalizations.of(context)!.wishlist,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.library,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: AppLocalizations.of(context)!.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: _selectedIndex == 1,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/isbn-scanner');
          },
          tooltip: 'Scanner',
          label: Text(AppLocalizations.of(context)!.addManga),
          icon: const Icon(Icons.document_scanner_rounded),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1,color: Colors.black),
              borderRadius: BorderRadius.circular(100)
          ),
          ),
        ),
    );
  }
}
