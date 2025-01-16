import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/provider/language_provider.dart';
import 'package:manga_library/provider/theme_provider.dart';
import 'package:manga_library/provider/user_provider.dart';
import 'package:manga_library/screen/MyLibraryPage.dart';
import 'package:manga_library/screen/options.dart';
import 'package:manga_library/service/shared_pref_service.dart';
import 'package:provider/provider.dart';
import 'list.dart';
import './routes.dart';

import 'service/firestore_service.dart';
import 'screen/options.dart';



Future<void> main() async {
  // Charger le fichier .env
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour les appels async dans `main`
  await Firebase.initializeApp(); // Initialisation de Firebase

  final connectivityResult = await Connectivity().checkConnectivity();
  bool isConnected = (connectivityResult != ConnectivityResult.none);
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),

    ],
    child : MyApp(hasInternet:  isConnected,)));

}

class MyApp extends StatelessWidget {
  final bool hasInternet;
  const MyApp({super.key, required this.hasInternet});

  static const String _title = 'Manga Vault';

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    FirebaseAuth.instance
        .setLanguageCode('fr'); // Définir la langue sur "fr" pour le français

    User? user;
    user = FirebaseAuth.instance.currentUser;
    user?.reload();
    if (user != null) {
      loadUserFromPreferences(context);
    }
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          cardColor: Colors.white70,
          primaryColor: Colors.white,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          useMaterial3: true,
          cardColor: Colors.grey.shade800,
          primaryColor: Colors.white
        ),
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

        locale: languageProvider.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('fr'), // French
        ],
        routes: customRoutes,

        debugShowCheckedModeBanner: false,
        title: _title,
        initialRoute: !hasInternet ? '/no-internet' :  user == null ? '/login' : '/',

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
  final PageController _pageController =
      PageController(); // Pour la gestion du swipe

  // Liste des pages de l'application
  late Future<List<Widget>> _pages;

  @override
  void initState() {
    super.initState();
    _pages = _loadData(); // Charger le fichier CSV au démarrage
  }

  // Charger et parser le fichier CSV
  Future<List<Widget>> _loadData() async {
    List<Serie> allSeries = await getAllSerieFromFirestore();
    List<String> mangaTitles = allSeries.map((row) => row.name!).toList();
    String userid = FirebaseAuth.instance.currentUser!.uid;
    getUserWishlist(userid);
    getFriendWishlist();

    return [
      const Center(
          child: Text("TODO : WISHLIST", style: TextStyle(fontSize: 30))),
      MyLibrarypage(allSeries: allSeries),
      MySearchPage(
          titles: mangaTitles), // Passer la liste des titres à MySearchPage
      Options()
    ];
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
      body: FutureBuilder(
        future: _pages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: snapshot.data!,
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: AppLocalizations.of(context)!.wishlist, // Accès direct aux localisations
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!
                .library, // Accès direct aux localisations
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: AppLocalizations.of(context)!
                .search, // Accès direct aux localisations
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!
                .settings, // Accès direct aux localisations
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/isbn-scanner');
        },
        tooltip: 'Scanner',
        child: const Icon(Icons.document_scanner_rounded),
      ),
    );
  }
}
