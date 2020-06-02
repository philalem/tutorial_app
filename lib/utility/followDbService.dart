import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowDbService {
  final String uid;
  final CollectionReference followInfoCollection =
      Firestore.instance.collection('follow-info');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FollowDbService({this.uid});

  Future<void> updateUserInfo(
      String name,
      String username,
      String email,
      String password,
      List<String> interests,
      int numberFollowing,
      int numberFollowers) async {
    return await followInfoCollection.document(uid).setData({
      'name': name,
      'username': username,
      'email': email,
      'interests': interests,
      'photo-url': '',
      'number-following': numberFollowing,
      'number-followers': numberFollowers,
    });
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    DocumentReference ref = followInfoCollection.document(uid);
    ref.updateData({"photo-url": photoUrl});
  }

  Future<void> addToFollowing(String uidToBeFollowed) async {
    await followInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(1)});
    return followInfoCollection
        .document(uid)
        .collection('following')
        .document(uidToBeFollowed)
        .setData({'uid': uidToBeFollowed}).whenComplete(
            () => print("User followed successfully."));
  }

  Future<void> removeFromFollowing(String uidToBeUnFollowed) async {
    await followInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(-1)});
    return followInfoCollection
        .document(this.uid)
        .collection('following')
        .document(uidToBeUnFollowed)
        .delete()
        .whenComplete(() => print("User unfollowed successfully."));
  }

  Future<bool> isFollowing(String uidToBeFollowed) async {
    bool isFollowing = false;
    var usersRef = followInfoCollection
        .document(this.uid)
        .collection('following')
        .document(uidToBeFollowed);
    await usersRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        isFollowing = true;
      }
    });
    return isFollowing;
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
      photoUrl: snapshot['photo-url'],
      numberFollowing: snapshot['number-following'],
      numberFollowers: snapshot['number-followers'],
    );
  }

  Future<String> getUsersName() async {
    String userName;
    final FirebaseUser user = await _auth.currentUser();
    followInfoCollection.document(user.uid).snapshots().map((snapshot) {
      userName = snapshot['name'];
    });

    return userName;
  }

  Stream<QuerySnapshot> get name {
    return followInfoCollection.snapshots();
  }

  Stream<UserData> getNames() {
    return followInfoCollection
        .document(uid)
        .snapshots()
        .map(_mapUserData)
        .handleError((e) {
      print(e);
    });
  }
}
