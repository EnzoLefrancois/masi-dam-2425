import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/service/firestore_service.dart';

import '../model/serie.dart';

class MyLibrarypage extends StatefulWidget {
  const MyLibrarypage({super.key, required this.allSeries});

  final List<Serie> allSeries;

  @override
  State<MyLibrarypage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibrarypage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  late Future<bool> _hasData;

  int _selectedFilter = -1;
  int _selectedSort = -1;

  late List<OwnedTome> _userOwnedTomeIsbn;
  final List<Serie> _ownedSeries = [];
  late List<Serie> _filterOwnedSeries;

  Future<bool> _loadData() async {
    try {
      MyBooks allOwnedTome = await getUsersAllOwnedBooks();
      _userOwnedTomeIsbn = allOwnedTome.books!;

      if (_userOwnedTomeIsbn.isNotEmpty) {
        _setOwned();
      }

      _filterOwnedSeries = _ownedSeries;

      return true;
    } catch (e) {
      return false;
    }
  }

  void _setOwned() {
    List<Serie> allExistingSeries = widget.allSeries;
    for (var ownedIsbn in _userOwnedTomeIsbn) {
      Serie? ownedSerie = allExistingSeries.firstWhere((serie) {
        return serie.serieId! == ownedIsbn.serieId;
      });

      int index = _ownedSeries.indexOf(ownedSerie);
      if (index != -1) {
        _ownedSeries[index].nbOwnedTomes++;
        if (ownedIsbn.readingStatus! == 1) {
          ownedSerie.reading_status = 1;
        }
      } else {
        ownedSerie.nbOwnedTomes = 1;
        ownedSerie.reading_status = ownedIsbn.readingStatus!;
        _ownedSeries.add(ownedSerie);
      }
    }
    // _ownedSeries.addAll(allExistingSeries);
  }

  @override
  void initState() {
    super.initState();
    _hasData = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          _searchSide(),
          FutureBuilder(
              future: _hasData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Expanded(
                    child: _ownedSeries.isEmpty
                        ? Text(AppLocalizations.of(context)!.libraryEmpty)
                        : _listSide());
              }),
        ],
      ),
    );
  }

  void _filterTitles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filterOwnedSeries = _ownedSeries;
      } else {
        _filterOwnedSeries = _ownedSeries
            .where((serie) =>
                serie.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _searchSide() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: searchController,
            focusNode: searchFocus,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.searchManga,
              border: const OutlineInputBorder(),
            ),
            onChanged: _filterTitles,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        PopupMenuButton<int>(
          onSelected: (value) {
            setState(() {
              _filterOwnedSeries = _ownedSeries;
              if (_selectedFilter == value) {
                _selectedFilter = -1;
              } else {
                _selectedFilter = value;
                if (_selectedSort == 0) {
                  _filterOwnedSeries.sort((a, b) => a.name!.compareTo(b.name!));
                } else if (_selectedSort == 1) {
                  _filterOwnedSeries.sort((b, a) => a.name!.compareTo(b.name!));
                }
                if (value == 0) {
                  _filterOwnedSeries = _filterOwnedSeries
                      .where((serie) => serie.reading_status == 1)
                      .toList();
                }
              }
            });
          },
          itemBuilder: (context) => [
            _buildMenuItem(
                context,
                0,
                AppLocalizations.of(context)!.currentlyReading,
                _selectedFilter == 0),
          ],
          child: Container(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              shape: const CircleBorder(),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.filter_list,
              size: 25,
              color: Theme.of(context).primaryColor
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        PopupMenuButton<int>(
          onSelected: (value) {
            setState(() {
              _filterOwnedSeries = _ownedSeries;
              if (_selectedSort == value) {
                _selectedSort = -1;
              } else {
                _selectedSort = value;
                if (_selectedFilter == 0) {
                  _filterOwnedSeries = _filterOwnedSeries
                      .where((serie) => serie.reading_status == 1)
                      .toList();
                }
                if (value == 0) {
                  _filterOwnedSeries.sort((a, b) => a.name!.compareTo(b.name!));
                } else {
                  _filterOwnedSeries.sort((b, a) => a.name!.compareTo(b.name!));
                }
              }
            });
          },
          itemBuilder: (context) => [
            _buildMenuItem(
                context,
                0,
                AppLocalizations.of(context)!.sortByNameAscending,
                _selectedSort == 0),
            _buildMenuItem(
                context,
                1,
                AppLocalizations.of(context)!.sortByNameDescending,
                _selectedSort == 1),
          ],
          child: Container(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              shape: const CircleBorder(),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.sort_by_alpha_outlined,
              size: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ]),
    );
  }

  PopupMenuItem<int> _buildMenuItem(
      BuildContext context, int value, String text, bool isSelected) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).primaryColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  Widget _listSide() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _filterOwnedSeries.length,
        itemBuilder: (_, index) {
          List<OwnedTome> ownedTomeOfCurrentSeries =
              _userOwnedTomeIsbn.where((owned) {
            return owned.serieId == _filterOwnedSeries[index].serieId;
          }).toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/series-details', arguments: {
                  'serie': _filterOwnedSeries[index],
                  'ownedTomes': ownedTomeOfCurrentSeries
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).cardColor),//todo
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          shape: BoxShape.rectangle,
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Image.network(
                          _filterOwnedSeries[index].mainCover!,
                          width: 100,
                          height: 150,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _filterOwnedSeries[index].name!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            Text(
                              '${_filterOwnedSeries[index].nbOwnedTomes}/${_filterOwnedSeries[index].nbVolume} ${AppLocalizations.of(context)!.tome}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                            Text(
                              _filterOwnedSeries[index].reading_status == 1
                                  ? AppLocalizations.of(context)!
                                      .currentlyReading
                                  : "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
