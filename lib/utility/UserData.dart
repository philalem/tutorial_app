class UserData {
  final String uid;
  String email;
  String name;
  String photoUrl;
  List<String> interests;
  List<String> followers;
  List<String> following;

  UserData(
      {this.uid,
      this.email,
      this.name,
      this.interests,
      this.followers,
      this.following,
      this.photoUrl});
}
