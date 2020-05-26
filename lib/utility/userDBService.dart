import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDbService {
  final String uid;
  final CollectionReference creaidCollection =
      Firestore.instance.collection('user-info');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDbService({this.uid});

  Future<void> updateUserInfo(String name, String email, String password,
      List<String> interests) async {
    return await creaidCollection.document(uid).setData({
      'name': name,
      'email': email,
      'interests': interests,
      'photo-url': '',
    });
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    DocumentReference ref = creaidCollection.document(uid);
    ref.updateData({"photo-url": photoUrl});
  }

  List<String> _nameFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.data['name'] ?? '';
    });
  }

  UserData _mapUserData(DocumentSnapshot snapshot) {
    return UserData(
        email: snapshot['email'],
        name: snapshot['name'],
        interests: List.from(snapshot['interests']),
        photoUrl: snapshot['photo-url']);
  }

  Future<String> getUsersName() async {
    String userName;
    final FirebaseUser user = await _auth.currentUser();
    creaidCollection.document(user.uid).snapshots().map((snapshot) {
      userName = snapshot['name'];
    });

    return userName;
  }

  Stream<QuerySnapshot> get name {
    return creaidCollection.snapshots();
  }

  Stream<UserData> getNames() {
    return creaidCollection.document(uid).snapshots().map(_mapUserData);
  }
}
