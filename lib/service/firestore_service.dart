import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/model/whishlist.dart';

Future<void> createUserCollection() async {
  String userid = FirebaseAuth.instance.currentUser!.uid;
  try {
    await FirebaseFirestore.instance
        .collection('user_owned_book')
        .doc(userid)
        .set({});
    await FirebaseFirestore.instance
        .collection('user_whishlist')
        .doc(userid)
        .set({});
  } catch (e) {
    print('Erreur lors de la creation des collections : $e');
  }
}

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
          if (key.startsWith('Vol')) {
            Map<String, dynamic> volumeData = value as Map<String, dynamic>;
            Tome tome = Tome.fromJson(volumeData, mangaName, key);
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
      MyBooks m = MyBooks.fromJson(userDoc.data()!);
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

Future<bool> addTomeToOwnedList(OwnedTome newOwnedTome) async {
  try {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> newTomeData = newOwnedTome.toJson();
    await FirebaseFirestore.instance
        .collection('user_owned_book')
        .doc(userid)
        .set({
      newOwnedTome.isbn!: newTomeData,
    }, SetOptions(merge: true));
    return true;
  } catch (e) {
    print('Erreur lors de l\'ajout du tome : $e');

    return false;
  }
}

Future<bool> removeTomeToOwnedList(OwnedTome ownedTome) async {
  try {
    String userid = FirebaseAuth.instance.currentUser!.uid;

    // Utilisez FieldValue.delete() pour supprimer une clé spécifique
    await FirebaseFirestore.instance
        .collection('user_owned_book')
        .doc(userid)
        .update({
      ownedTome.isbn!: FieldValue.delete(),
    });

    print('Tome supprimé avec succès.');
    return true;
  } catch (e) {
    print('Erreur lors de la suppression du tome : $e');
    return false;
  }
}

Future<bool> updateTomeReadingStatus(String isbn, int newReadingStatus) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Met à jour uniquement le champ `readingStatus` d'un tome spécifique
    await FirebaseFirestore.instance
        .collection('user_owned_book')
        .doc(userId)
        .update({
      '$isbn.reading_status': newReadingStatus,
    });

    print('Le champ readingStatus a été mis à jour avec succès.');
    return true;
  } catch (e) {
    print('Erreur lors de la mise à jour de readingStatus : $e');
    return false;
  }
}
