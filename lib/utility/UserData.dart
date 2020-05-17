class UserData {
  final String uuid;
  String email;
  String name;
  String photoUrl;
  List<String> interests;
  List<String> followers;
  List<String> following;

  UserData({this.uuid, this.email, this.name, this.interests, this.followers, this.following, this.photoUrl});
}