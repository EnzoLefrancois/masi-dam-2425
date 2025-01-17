import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manga_library/model/my_books.dart';
import 'package:manga_library/model/tome.dart';
import 'package:manga_library/model/serie.dart';
import 'package:manga_library/model/user_model.dart';
import 'package:manga_library/model/whishlist.dart';

Future<UserModel?> getUserDetailsFromFirebase() async {
  String userid = FirebaseAuth.instance.currentUser!.uid;

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get();

    if (userDoc.exists) {
      UserModel m = UserModel.fromJson(userDoc.data()!);
      return m;
    } else {
    }
  } catch (_) {
  }
  return null;

}

Future<void> saveUserToFirestore(String firstName, String lastName, String photoUrl) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'firstName': firstName,
      'lastName': lastName,
      // 'photoUrl': photoUrl,
      'photoUrl' : "https://images.unsplash.com/photo-1524952249965-023a2a31663d?w=500&h=500",
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}


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
  } catch (_) {
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
            Tome tome = Tome.fromJson(volumeData, mangaName, key, serie.serieId!);
            serie.addTome(tome);
          }
        });
        allSeries.add(serie);
      }
    }
  } catch (_) {
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
      return MyBooks();
    }
  } catch (_) {
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
    }
  } catch (_) {
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
      List<FriendWishlist> friendwishlist = [];
      var friendData = userDoc.data();

      for (var value in friendData!.values) {
        Map<String, dynamic> data = value as Map<String, dynamic>;
        FriendWishlist friend = FriendWishlist.fromJson(data);
        List<Wishlist> fWish = await getUserWishlist(friend.friendUserId!);
        friend.wishlist = fWish;
        friendwishlist.add(friend);
      }

      return friendwishlist;
    }
  } catch (_) {
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
    await removeTomeFromWishlist(newOwnedTome.isbn!);
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> removeTomeToOwnedList(OwnedTome ownedTome) async {
  try {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('user_owned_book')
        .doc(userid)
        .update({
      ownedTome.isbn!: FieldValue.delete(),
    });

    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> updateTomeReadingStatus(String isbn, int newReadingStatus) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('user_owned_book')
        .doc(userId)
        .update({
      '$isbn.reading_status': newReadingStatus,
    });
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> addFriedWishlist(Map<String, dynamic> jsonData) async {
  String userid = FirebaseAuth.instance.currentUser!.uid;
  try {
    final userDoc = await FirebaseFirestore.instance
            .collection('friend_whishlist')
            .doc(userid)
            .get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance
            .collection('friend_whishlist')
            .doc(userid)
            .set({});
    }


    int count = (await getUserWishlist(userid)).length;
    await FirebaseFirestore.instance
        .collection('friend_whishlist')
        .doc(userid)
        .set({
      "$count": jsonData,
    } , SetOptions(merge: true));

    return true;
  } catch (_) {
  }
  return false;
}

Future<bool> addTomeToWishlist(Wishlist wish) async {
  try {
    String userid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> newWish = {
      "isbn": wish.isbn,
      "serie_id" : wish.serieId
    };
    await FirebaseFirestore.instance
        .collection('user_whishlist')
        .doc(userid)
        .set({
      '${wish.isbn}': newWish,
    }, SetOptions(merge: true));
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> removeTomeFromWishlist(String isbn) async {
  try {
    String userid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('user_whishlist')
        .doc(userid)
        .update({
      isbn: FieldValue.delete(),
    });

    return true;
  } catch (_) {
    return false;
  }
}
