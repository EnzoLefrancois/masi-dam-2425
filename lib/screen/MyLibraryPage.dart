import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/model/mybooks.dart';

class MyLibrarypage extends StatefulWidget {
  const MyLibrarypage({super.key, required this.allBooks});

  final List<LibraryBook> allBooks;

  @override
  State<MyLibrarypage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibrarypage> {
  TextEditingController searchController = TextEditingController(); // Contrôleur pour la recherche
  late Future<bool> _hasData;
  late List<Books> _ownedBooks;
  late List<LibraryBook> _filteredOwnedBooksLibrabrys;
  late List<LibraryBook> _ownedMainBook;

  int _selectedFilter = -1; 
  int _selectedSort = -1;


  Future<bool> _loadData() async {
    // todo get owned books from api
    final rawData = await rootBundle.loadString('assets/mybooks.json');
    MyBooks myBooks = MyBooks.fromJson(jsonDecode(rawData));
    _ownedBooks = myBooks.books ?? [];
    _ownedMainBook = _ownedBooks.isEmpty ? [] : _chargeMainBooks();
    _filteredOwnedBooksLibrabrys = _ownedMainBook;

    return true;
  }

  List<LibraryBook> _chargeMainBooks() {
    List<LibraryBook> masterBooks = [];
    List<LibraryBook> allBooks = widget.allBooks;


    for (var ownedBook in _ownedBooks) {
      LibraryBook? masterBook = allBooks.firstWhere ((book) {
        // mettre en miniscule, enlever tout les espaces, garder que les caractere
        return book.title!.toLowerCase().replaceAll(' ', '').replaceAll(new RegExp(r'[^\w\s]+'),'') ==
            ownedBook.mainTitle!.toLowerCase().replaceAll(' ', '').replaceAll(new RegExp(r'[^\w\s]+'),'');
      }, orElse: () => LibraryBook(title: ownedBook.mainTitle, cover: ownedBook.cover, readingStatus: ownedBook.readingStatus, nbBooks: 1));

      int index = masterBooks.indexOf(masterBook);

      if (index != -1) {
        masterBooks[index].nbOwnedBook++;
        if (ownedBook.readingStatus == "Lecture en cours") {
          masterBook.readingStatus = ownedBook.readingStatus;
        }
      } else {
        masterBook.nbOwnedBook = 1;
        masterBook.readingStatus = ownedBook.readingStatus;
        masterBooks.add(masterBook);
      }
    }

    return masterBooks;
  }

  @override
  void initState() {
    super.initState();
    _hasData = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        _searchSide(),
        FutureBuilder(future: _hasData, builder: (context, snapshot) {
          if (!snapshot.hasData)
            return  Expanded(child: Center(child:CircularProgressIndicator()),);
          return Expanded(child: _ownedBooks.isEmpty ? Text("IT IS EMPTY") :  _listSide());
        }),
    
      ],
    );

  }

  void _filterTitles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOwnedBooksLibrabrys = _ownedMainBook; // Afficher tous les titres si la recherche est vide
      } else {
        _filteredOwnedBooksLibrabrys =  _ownedMainBook.where((book) =>
        book.title!.toLowerCase().contains(query.toLowerCase())).toList();

      }
    });
  }

  Widget _searchSide() {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          children: [
           Expanded(child: TextField(
             controller: searchController,
             decoration: const InputDecoration(
               labelText: 'Search Manga',
               border: OutlineInputBorder(),
             ),
             onChanged: _filterTitles, // Filtrer les titres lors de la saisie
           ),),
            SizedBox(width: 20,),
            PopupMenuButton<int>(
              onSelected: (value) {
                setState(() {
                  _filteredOwnedBooksLibrabrys = _ownedMainBook;
                  if (_selectedFilter == value) {
                    _selectedFilter = -1;
                  } else {
                    _selectedFilter = value;
                    if (_selectedSort == 0) {
                      _filteredOwnedBooksLibrabrys.sort((a,b) => a.title!.compareTo(b.title!));
                    } else if (_selectedSort == 1) {
                      _filteredOwnedBooksLibrabrys.sort((b,a) => a.title!.compareTo(b.title!));
                    }
                    if (value == 0) {
                      _filteredOwnedBooksLibrabrys = _filteredOwnedBooksLibrabrys.where((book) =>
                          book.readingStatus!.toLowerCase() == ("Lecture en cours".toLowerCase())).toList();
                    } 
                  }
                });
              },
              itemBuilder: (context) => [
                _buildMenuItem(context, 0,"Lecture en cours", _selectedFilter == 0),
              ],
              child: Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  shape: CircleBorder(),
                ),
                padding: EdgeInsets.all(10), // Espace autour de l'icône
                child: Icon(
                  Icons.filter_list,
                  size: 25,
                  color: Colors.white, // Couleur de l'icône
                ),
              ),
            ),
            SizedBox(width: 10,),
            PopupMenuButton<int>(
              onSelected: (value) {
                setState(() {
                  _filteredOwnedBooksLibrabrys = _ownedMainBook;
                  if (_selectedSort == value) {
                    _selectedSort = -1;
                  } else {
                    _selectedSort = value;
                    if (_selectedFilter == 0) {
                      _filteredOwnedBooksLibrabrys = _filteredOwnedBooksLibrabrys.where((book) =>
                          book.readingStatus!.toLowerCase() == ("Lecture en cours".toLowerCase())).toList();
                    }
                    if (value == 0) {
                      _filteredOwnedBooksLibrabrys.sort((a,b) => a.title!.compareTo(b.title!));
                    } else {
                      _filteredOwnedBooksLibrabrys.sort((b,a) => a.title!.compareTo(b.title!));
                    }


                  }
                });
              },
              itemBuilder: (context) => [
                _buildMenuItem(context, 0,"Trie par nom A-Z", _selectedSort == 0),
                _buildMenuItem(context, 1, "Trie par nom Z-A", _selectedSort == 1),
              ],
              child: Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  shape: CircleBorder(),
                ),
                padding: EdgeInsets.all(10), // Espace autour de l'icône
                child: Icon(
                  Icons.sort_by_alpha_outlined,
                  size: 25,
                  color: Colors.white, // Couleur de l'icône
                ),
              ),
            ),


          ]
      ),
    );
  }

  PopupMenuItem<int> _buildMenuItem(BuildContext context,int value, String text, bool isSelected) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected 
                  ? Theme
                  .of(context)
                  .colorScheme
                  .primary
                  : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) // Ajoute une icône pour indiquer la sélection
            Icon(Icons.check, color: Theme
                .of(context)
                .colorScheme
                .primary),
        ],
      ),
    );
  }

  Widget _listSide() {
     return  Padding(
       padding: const EdgeInsets.all(8.0),
       child: ListView.builder(
        itemCount: _filteredOwnedBooksLibrabrys.length,
        itemBuilder: (_,index)
        {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: InkWell(
              onTap: () {
                print('click $index');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  shape: BoxShape.rectangle,
                  color: Colors.white70
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        shape: BoxShape.rectangle,
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(_filteredOwnedBooksLibrabrys[index].cover! , width: 100, height: 150,),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _filteredOwnedBooksLibrabrys[index].title!,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(
                            '${_filteredOwnedBooksLibrabrys[index].nbOwnedBook}/${_filteredOwnedBooksLibrabrys[index].nbBooks} Tomes',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          Text(
                            '${_filteredOwnedBooksLibrabrys[index].readingStatus}',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                          
                        ],
                      ),
                    )
                  ]
                ),
              ),
            ),
          )
          ;
        },
           ),
     );
  }
}
