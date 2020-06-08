class UserData {
  final String uid;
  String username;
  String email;
  String name;
  String photoUrl;
  int numberFollowing;
  int numberFollowers;
  List<String> interests;
  List<String> followers;
  List<String> following;
  List<String> videos;
  String feedId;

  UserData({
    this.uid,
    this.username,
    this.email,
    this.name,
    this.interests,
    this.followers,
    this.following,
    this.photoUrl,
    this.numberFollowers,
    this.numberFollowing,
    this.feedId
  });
}
