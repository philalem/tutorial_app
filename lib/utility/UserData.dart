class UserData {
  final String uid;
  String username;
  String name;
  String photoUrl;
  String bio;
  int numberFollowing;
  int numberFollowers;
  String feedId;

  UserData(
      {this.uid,
      this.username,
      this.name,
      this.bio,
      this.photoUrl,
      this.numberFollowers,
      this.numberFollowing,
      this.feedId});
}
