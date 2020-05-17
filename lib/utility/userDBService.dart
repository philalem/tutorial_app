import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDbService {
  final String uuid;
  final CollectionReference creaidCollection = Firestore.instance.collection('userInfo');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDbService({this.uuid});

  Future<void> updateUserInfo(String name, String email, String password, List<String> interests) async {
    return await creaidCollection.document(uuid).setData({
      'name': name,
      'email': email,
      'password': password,
      'interests': interests,
    });
  }

  List<String> _nameFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return doc.data['name'] ?? '';
    });
  }

  UserData _mapUserData(DocumentSnapshot snapshot){
    return UserData(
      uuid: uuid,
      email: snapshot['email'],
      name: snapshot['name'],
      interests: List.from(snapshot['interests']),
      followers: List.from(snapshot['followers']),
      following: List.from(snapshot['following']),
      photoUrl: snapshot['photoUrl']
    );
  }

  Future<List<DocumentSnapshot>> getUsername() async {
    final FirebaseUser user = await _auth.currentUser();
    return creaidCollection.document(user.uid).snapshots().toList();
    
  }

  Stream<QuerySnapshot> get name {
    return creaidCollection.snapshots();
  }

  Stream<UserData> getNames() {
    return creaidCollection.document(uuid).snapshots()
      .map(_mapUserData);
  }

}