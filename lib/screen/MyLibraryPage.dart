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
  late List<LibraryBook> _ownedBooksMaster;

  int? _selectedFilter; // Variable pour stocker l'option sélectionnée


  Future<bool> _loadData() async {
    // todo get owned books from api
    final rawData = await rootBundle.loadString('assets/mybooks.json');
    MyBooks myBooks = MyBooks.fromJson(jsonDecode(rawData));
    _ownedBooks = myBooks.books ?? [];
    _ownedBooksMaster = _ownedBooks.isEmpty ? [] : _chargeMasterBooks();
    _filteredOwnedBooksLibrabrys = _ownedBooksMaster;

    return true;
  }

  List<LibraryBook> _chargeMasterBooks() {
    List<LibraryBook> masterBooks = [];
    List<LibraryBook> allBooks = widget.allBooks;


    for (var ownedBook in _ownedBooks) {
      // Rechercher le livre correspondant dans allBooks

      LibraryBook? masterBook = allBooks.firstWhere ((b) {
        return b.title!.toLowerCase().replaceAll(' ', '').replaceAll(new RegExp(r'[^\w\s]+'),'') ==
            ownedBook.mainTitle!.toLowerCase().replaceAll(' ', '').replaceAll(new RegExp(r'[^\w\s]+'),'');
      }, orElse: () => LibraryBook(title: ownedBook.mainTitle, cover: ownedBook.cover, readingStatus: ownedBook.readingStatus, nbBooks: 1));

      if (masterBook!=null) {

        if (masterBooks.contains(masterBook)) {
          int index = masterBooks.indexOf(masterBook);
          masterBooks[index].nbOwnedBook++;

          if (ownedBook.readingStatus == "  -  Lecture en cours") {
            masterBook.readingStatus = ownedBook.readingStatus;
          }

        } else {
          masterBook.nbOwnedBook = 1;
          masterBook.readingStatus = ownedBook.readingStatus;
          masterBooks.add(masterBook);
        }
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
    return  Container(
          child: Column(
            children: [
              _searchSide(),
              FutureBuilder(future: _hasData, builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return  Expanded(child: Center(child:CircularProgressIndicator()),);
                return Expanded(child: _ownedBooks.isEmpty ? Text("IT IS EMPTY") :  _listSide());
              }),

            ],
          ),

    );

  }

  void _filterTitles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOwnedBooksLibrabrys = _selectedFilter == null ? _ownedBooksMaster : _filteredOwnedBooksLibrabrys; // Afficher tous les titres si la recherche est vide
      } else {
        _filteredOwnedBooksLibrabrys = _selectedFilter == null ?  _ownedBooksMaster.where((book) =>
        book.title!.toLowerCase().contains(query.toLowerCase())).toList() : _filteredOwnedBooksLibrabrys.where((book) =>
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
            SizedBox(width: 50,),
            PopupMenuButton<int>(
              onSelected: (value) {
                setState(() {
                  if (_selectedFilter == value) {
                    _filteredOwnedBooksLibrabrys = _ownedBooksMaster;
                    _selectedFilter = null;
                  } else {
                    _selectedFilter = value;
                    if (value == 0) {
                      _filteredOwnedBooksLibrabrys = _ownedBooksMaster.where((book) =>
                          book.readingStatus!.toLowerCase() == ("  -  Lecture en cours".toLowerCase())).toList();

                    } else  if (value == 1) {
                      _filteredOwnedBooksLibrabrys = _ownedBooksMaster;
                      _filteredOwnedBooksLibrabrys.sort((a,b) => a.title!.compareTo(b.title!));
                    } else {
                      _filteredOwnedBooksLibrabrys = _ownedBooksMaster;
                      _filteredOwnedBooksLibrabrys.sort((b,a) => a.title!.compareTo(b.title!));
                    }


                  }
                });
              },
              itemBuilder: (context) => [
                _buildMenuItem(context, 0,"Lecture en cours"),
                _buildMenuItem(context, 1,"Trie par nom A-Z"),
                _buildMenuItem(context, 2, "Trie par nom Z-A"),
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


          ]
      ),
    );
  }

  PopupMenuItem<int> _buildMenuItem(BuildContext context,int value, String text) {
    final bool isSelected = _selectedFilter ==
        value; // Vérifie si l'élément est sélectionné
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
    return  ListView.builder(
      itemCount: _filteredOwnedBooksLibrabrys.length,
      itemBuilder: (_,index)
      {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: InkWell(
            onTap: () {print(index);},
            child: Material(
              color: Colors.white60,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
                  child: Row(
                    children: [
                      Image.network(_filteredOwnedBooksLibrabrys[index].cover! , width: 100, height: 150,),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _filteredOwnedBooksLibrabrys[index].title!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_filteredOwnedBooksLibrabrys[index].nbOwnedBook}/${_filteredOwnedBooksLibrabrys[index].nbBooks} Tomes ${_filteredOwnedBooksLibrabrys[index].readingStatus}',
                          ),
                        ],
                      )
                    ]
                  ),
                ),
              ),
            ),
          ),
        )
        ;
      },
    );
  }
}
