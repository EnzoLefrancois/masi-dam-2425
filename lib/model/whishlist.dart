class Wishlist {
  String? isbn;
  int? serieId;

  Wishlist({this.isbn, this.serieId});

  Wishlist.fromJson(Map<String, dynamic> json) {
    isbn = json['isbn'];
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
