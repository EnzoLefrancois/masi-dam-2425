class Wishlist {
  String? isbn10;
  int? serieId;

  Wishlist({this.isbn10, this.serieId});

  Wishlist.fromJson(Map<String, dynamic> json) {
    isbn10 = json['isbn_10'];
    serieId = json['serie_id'];
  }
}

class FriendWishlist {
  String? friendName;
  String? friendUserId;
  List<Wishlist> wishlist = [];

  FriendWishlist({this.friendName, this.friendUserId});

  FriendWishlist.fromJson(Map<String, dynamic> json) {
    friendName = json['friend_name'];
    friendUserId = json['friend_userid'];
  }
}
