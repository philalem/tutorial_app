import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/VideoFeedObject.dart';
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
      'photo-url': 'https://firebasestorage.googleapis.com/v0/b/creaid-b4528.appspot.com/o/unknown-profile.png?alt=media&token=36b3cb28-743c-4352-ad53-32ec67387e0d',
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
        photoUrl: snapshot['photo-url'],
        videos: List.from(snapshot['video-stream']),
    );
  }

  List<VideoFeedObject> _mapVideoFeedObject(QuerySnapshot snapshot) {
    List<VideoFeedObject> res = new List();
      snapshot.documents.forEach((document) => 
        res.add(
          VideoFeedObject(
            author: document['author'],
            videoUrl: document['videoUrl'],
            likes: document['likes'],
            comments: List.from(document['comments']),
            documentId: document.documentID,
            uid: uid
          )
        )
      );

    return res;
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

  Stream<List<VideoFeedObject>> getUserFeed() {
    return creaidCollection.document(uid).collection('feeds').snapshots().map(_mapVideoFeedObject);
  }
}
