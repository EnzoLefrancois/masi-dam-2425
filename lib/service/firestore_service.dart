import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/model/whishlist.dart';

Future<List<Serie>> getAllSerieFromFirestore() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Serie> allSeries = [];
  try {
    QuerySnapshot mangaSnapshot = await firestore.collection('manga_db').get();

    for (var mangaDoc in mangaSnapshot.docs) {
      if (mangaDoc.exists) {
        Map<String, dynamic> mangaData =
            mangaDoc.data() as Map<String, dynamic>;
        String mangaName = mangaDoc.id;

        Serie serie = Serie.fromJson(mangaData, mangaName);
        // Parcourir chaque champ 'Vol' du document correspond au different tome
        mangaData.forEach((key, value) {
          if (key.startsWith('Vol.')) {
            Map<String, dynamic> volumeData = value as Map<String, dynamic>;
            Tome tome = Tome.fromJson(volumeData, mangaName);
            serie.addTome(tome);
          }
        });
        allSeries.add(serie);
      }
    }
  } catch (e) {
    print('Erreur lors de la récupération des mangas et tomes : $e');
  }

  return allSeries;
}

Future<MyBooks> getUsersAllOwnedBooks() async {
  String userid = FirebaseAuth.instance.currentUser!.uid;

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('user_owned_book')
        .doc(userid)
        .get();

    if (userDoc.exists) {
      MyBooks m = MyBooks.fromJson(userDoc.data()?['books']);
      return m;
    } else {
      print('Aucun document trouvé pour cet utilisateur.');
      return MyBooks();
    }
  } catch (e) {
    print('Erreur lors de la récupération des livres : $e');
    return MyBooks();
  }
}

Future<List<Wishlist>> getUserWishlist(String userid) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('user_whishlist')
        .doc(userid)
        .get();

    if (userDoc.exists) {
      List<Wishlist> wishlist = [];
      var wishData = userDoc.data();

      wishData!.forEach((key, value) {
        Map<String, dynamic> data = value as Map<String, dynamic>;
        Wishlist wish = Wishlist.fromJson(data);
        wishlist.add(wish);
      });

      return wishlist;
    } else {
      print('Aucun document trouvé pour cet utilisateur.');
    }
  } catch (e) {
    print('Erreur lors de la récupération des livres : $e');
  }
  return [];
}

Future<List<FriendWishlist>> getFriendWishlist() async {
  String userid = FirebaseAuth.instance.currentUser!.uid;
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('friend_whishlist')
        .doc(userid)
        .get();

    if (userDoc.exists) {
      print(userDoc.data());
      // foreach value
      // getUserWhishlist(friendId);

      List<FriendWishlist> friendwishlist = [];
      var friendData = userDoc.data();

      friendData!.forEach((key, value) async {
        Map<String, dynamic> data = value as Map<String, dynamic>;
        FriendWishlist friend = FriendWishlist.fromJson(data);
        List<Wishlist> f_wish = await getUserWishlist(friend.friendUserId!);
        friend.wishlist = f_wish;
        friendwishlist.add(friend);
      });

      return friendwishlist;
    } else {
      print('Aucun document trouvé pour cet utilisateur.');
    }
  } catch (e) {
    print('Erreur lors de la récupération des livres : $e');
  }
  return [];
}
