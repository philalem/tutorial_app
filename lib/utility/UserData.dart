class UserData {
  final String uid;
  String username;
  String name;
  String photoUrl;
  int numberFollowing;
  int numberFollowers;

  UserData({
    this.uid,
    this.username,
    this.name,
    this.photoUrl,
    this.numberFollowers,
    this.numberFollowing,
    this.feedId
  });
}
