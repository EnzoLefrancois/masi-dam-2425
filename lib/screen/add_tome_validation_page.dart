import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/service/firestore_service.dart';

class AddTomeValidationPage extends StatefulWidget {
  final HashSet<Tome> addTomes;
  const AddTomeValidationPage({super.key, required this.addTomes,});

  @override
  State<AddTomeValidationPage> createState() => _AddTomeValidationPageState();
}

class _AddTomeValidationPageState extends State<AddTomeValidationPage> {
  Map<int, bool> _isSelected = {};
  Map<String, bool> _isOwned = {};


  @override
  void initState() {
            for (var i=0; i<widget.addTomes.length ; i++) {
                          _isSelected[i] = true;

            }

    getUsersAllOwnedBooks().then((val) {
      setState(() {
        for (var book in val.books!) {
          _isOwned[book.isbn!] = true;
        }
        
        for (var i=0; i<widget.addTomes.length ; i++) {
          var t = widget.addTomes.elementAt(i);
          if (_isOwned.containsKey(t.isbn13)) {
          _isSelected[i] = false;

          } 
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add tome validation"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
          ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      ),
      body: Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: ListView.builder(
              itemCount: widget.addTomes.length,
              itemBuilder: (_, index) {
                bool owned = _isOwned.containsKey(widget.addTomes.elementAt(index).isbn13);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: owned ? Colors.red[100]  : _isSelected[index]! ?Colors.black12 : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network(
                                widget.addTomes.elementAt(index).cover!,
                                width: 80,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.addTomes.elementAt(index).seriesName!,
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                                    ),
                                    Text(
                                      widget.addTomes.elementAt(index).tomeName!,
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: owned ? (){} :  ()  {
                                  setState(() {
                                    _isSelected[index] =!_isSelected[index]!; 
                                  });
                                },
                                child: !owned && _isSelected[index]! ?
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 24,
                                ),
                              ) :
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: owned ? Color.fromARGB(255, 99, 95, 95) : Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                    ),
                                  ),
                              ),
                              
                            ],
                          ),
                          if (owned) Text("Vous le posseder déjà !!!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
                        ],
                      ),
                              
                  ),
                );
              }),
          ),
          Expanded(
            flex:1,
            child: ElevatedButton(
              onPressed: () async {
                List<Tome> selectedTome = [];
                for (var key_ in _isSelected.keys) {
                  if (_isSelected[key_]!) {
                    selectedTome.add(widget.addTomes.elementAt(key_));
                  }
                }
                for (var tome in selectedTome) {
                  OwnedTome ownedTome = OwnedTome(isbn: tome.isbn13, readingStatus: 0, serieId: tome.serieId);

                  bool add = await addTomeToOwnedList(ownedTome);
                  if (add) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "${ownedTome.isbn} ajouté avec sucès")
                      ),
                    );
                  }
                }
                Navigator.pop(context);
              }, 
              child: Text("Ajouter")))
        ],
      )
      
      )
    );
  }
}