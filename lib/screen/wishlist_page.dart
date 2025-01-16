import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/model/whishlist.dart';
import 'package:manga_library/service/firestore_service.dart';
import 'package:manga_library/widget/scanner_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../provider/user_provider.dart';
class WishlistPage extends StatefulWidget {
  final List<Serie> allSeries;
  const WishlistPage({super.key, required this.allSeries});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {

  late Future<bool> _hasData;
  late List<Wishlist> _userWishlist;
  late List<FriendWishlist> _friendWishlist;


  @override
  void initState() {
    super.initState();
    _hasData = _loadData();
  }

  Future<bool> _loadData() async {
    try {
      String userid = FirebaseAuth.instance.currentUser!.uid;
      _userWishlist = await getUserWishlist(userid);
      _friendWishlist = await getFriendWishlist();

      return true;
    } catch (_) {
      return false;
    }
  }

  final _singleChildController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _singleChildController,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Liste de souhait", style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async{
                        await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext alertCtx) {
                                return AlertDialog(
                                  content: Builder(
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        width: 200.0, // Définissez la largeur
                                        height: 200.0, // Définissez la hauteur
                                        child: ScannerWidget(
                                          onScan: (code) async {
                                            String qrCodeResult = code.code!;
                                            // Décoder le JSON
                                            var decodedData = json.decode(qrCodeResult)  as Map<String, dynamic>; 

                                            bool isAdded = await addFriedWishlist(decodedData);
                                            if (isAdded) {
                                              String? friendName = decodedData['friend_name'];
                                              ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Wishlist de ${friendName} ajouté avec succès')),
                                              ) ;
                                              _friendWishlist = await getFriendWishlist();
                                              setState(() {
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Wishlist non ajouté'))
                                              ) ;
                                            }
                                            Navigator.pop(context);                       
                                          } ,
                                        )     
                                      );
                                    },
                                  ),
                                );});


                        
                      },  
                      icon: Icon(Icons.barcode_reader),),
                      IconButton(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            var userinfo = Provider.of<UserProvider>(context, listen: false).user;

                            String uid = user.uid;
                            String? name =  userinfo?.firstName!;
                            Map<String, String> jsonData = {
                              "friend_userid": uid,
                              "friend_name": name!,
                            };
                            String qrData = json.encode(jsonData);
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext alertCtx) {
                                return AlertDialog(
                                  content: Builder(
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        width: 200.0, // Définissez la largeur
                                        height: 200.0, // Définissez la hauteur
                                        child: QrImageView(
                                          data: qrData, // Données que vous souhaitez encoder dans le QR code
                                          version: QrVersions.auto,
                                          size: 200.0, // Taille du QR code
                                        ),
                                      );
                                    },
                                  ),
                                );});
                          }
                        }, 
                        icon: Icon(Icons.share)
                        ),
                  ],
                ),
                
              ],
            ),
            FutureBuilder(
                  future: _hasData, 
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    if (_friendWishlist.isEmpty) {
                      return _userWishlistBuild(context);
                    } else {
                      return _userAndFriendWishlistBuild(context);
                    }
                    
                  }
                  )
          
          ],
        ),
      ),
    );
  }

  Widget _userWishlistBuild(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ma wishlist",style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
          _userWishlist.isEmpty ?
          SizedBox(
            height: _friendWishlist.isNotEmpty ? 180 :  MediaQuery.of(context).size.height/1.7,
            child: Center(child: Text("Pas de wishlist", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),)):
          SizedBox(
            height: _friendWishlist.isNotEmpty ? 180 :  MediaQuery.of(context).size.height/1.7,
            child: ListView.builder(
              itemCount: _userWishlist.length,
              // controller:  _friendWishlist.isNotEmpty ? _singleChildController : null,
              scrollDirection:  Axis.horizontal, 
              shrinkWrap: true,
              itemBuilder: (_, index) {
                Serie serie = widget.allSeries.firstWhere((s) => s.serieId == _userWishlist[index].serieId);
                Tome tome = serie.tomes!.firstWhere((t) {
                   bool is13 = _userWishlist[index].isbn!.trim().replaceAll("-", "").length == 13;
                    return is13
                        ? _userWishlist[index].isbn! == t.isbn13
                        : _userWishlist[index].isbn! == t.isbn10;
                });
                return _coverBuilder(tome, serie, context);

              }
            ),
          ),
        ],
      );

  }

  Widget _coverBuilder(Tome tome,Serie serie,  BuildContext context) {
    return GestureDetector(
      onTap: () async {
          MyBooks allOwnedTome = await getUsersAllOwnedBooks();
          List<OwnedTome> ownedTome = allOwnedTome.books!;
          Navigator.pushNamed(context, "/tome-details", arguments: {
            'tome': tome,
            'serie': serie,
            'ownedTomes': ownedTome
          }).then((_) async {
            String userid = FirebaseAuth.instance.currentUser!.uid;

            _userWishlist = await getUserWishlist(userid);
            setState(() {
            
          });});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Image.network(
          tome.cover!,
          height: _friendWishlist.isNotEmpty ? 180 : MediaQuery.of(context).size.height /1.7, 
        ),
                          
      ),
    );
  }

  Widget _userAndFriendWishlistBuild(BuildContext context) {
    return Column(
      children: [
        _userWishlistBuild(context),
        SizedBox(
          // height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: _friendWishlist.length,
              shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(), 
              itemBuilder: (_, index) {
                List<Wishlist> wishlist = _friendWishlist[index].wishlist;
                String? friendName = _friendWishlist[index].friendName;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Wishlist de $friendName!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150, 
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, 
                        itemCount: wishlist.length,
                        shrinkWrap: true,
                        itemBuilder: (_, tomeIndex) {
                          Wishlist userWishlistItem = wishlist[tomeIndex];
                          Serie serie = widget.allSeries.firstWhere((s) => s.serieId == userWishlistItem.serieId);
                          Tome tome = serie.tomes!.firstWhere((t) {
                            bool is13 = userWishlistItem.isbn!.trim().replaceAll("-", "").length == 13;
                            return is13
                              ? userWishlistItem.isbn! == t.isbn13
                              : userWishlistItem.isbn! == t.isbn10;
                          });
                          return  _coverBuilder(tome,serie, context);
                              
                        },
                      ),
                    ),
                  ],
                );

              }
            ),
          ),
      ],
    );
  }


}