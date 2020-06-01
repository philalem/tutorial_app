import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDbService {
  final String uid;
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user-info');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDbService({this.uid});

  Future<void> updateUserInfo(String name, String username, String email,
      String password, List<String> interests) async {
    return await userInfoCollection.document(uid).setData({
      'name': name,
      'username': username,
      'email': email,
      'interests': interests,
      'photo-url': '',
    });
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    DocumentReference ref = userInfoCollection.document(uid);
    ref.updateData({"photo-url": photoUrl});
  }

  Future<void> addToFollowing(String uidToBeFollowed) async {
    return userInfoCollection
        .document(this.uid)
        .collection('following')
        .document(uidToBeFollowed)
        .setData({'uid': uidToBeFollowed});
  }

  Future<bool> isFollowing(String uidToBeFollowed) async {
    var usersRef = userInfoCollection
        .document(this.uid)
        .collection('following')
        .document(uidToBeFollowed);
    usersRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        return true;
      }
    });
    return false;
  }

  List<String> _nameFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data['name'] ?? '';
    });
  }

  UserData _mapUserData(DocumentSnapshot snapshot) {
    return UserData(
        username: snapshot['username'],
        email: snapshot['email'],
        name: snapshot['name'],
        interests: List.from(snapshot['interests']),
        photoUrl: snapshot['photo-url']);
  }

  Future<String> getUsersName() async {
    String userName;
    final FirebaseUser user = await _auth.currentUser();
    userInfoCollection.document(user.uid).snapshots().map((snapshot) {
      userName = snapshot['name'];
    });

    return userName;
  }

  Stream<QuerySnapshot> get name {
    return userInfoCollection.snapshots();
  }

  Stream<UserData> getNames() {
    return userInfoCollection.document(uid).snapshots().map(_mapUserData);
  }
}
