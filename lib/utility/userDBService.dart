import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/VideoFeedObject.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDbService {
  final String uid;
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user-info');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDbService({this.uid});

  Future<void> updateUserInfo(String name, String username,
      List<String> interests, int numberFollowing, int numberFollowers) async {
    return await userInfoCollection.document(uid).setData({
      'name': name,
      'username': username,
      'interests': interests,
      'number-following': numberFollowing,
      'number-followers': numberFollowers,
    });
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    DocumentReference ref = userInfoCollection.document(uid);
    ref.updateData({"photo-url": photoUrl});
  }

  Future<void> incrementNumberFollowing() async {
    return await userInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(1)});
  }

  Future<void> decrementNumberFollowing() async {
    return await userInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(-1)});
  }

  UserData _mapUserData(DocumentSnapshot snapshot) {
    return UserData(
      username: snapshot['username'],
      name: snapshot['name'],
      photoUrl: snapshot['photo-url'],
      numberFollowing: snapshot['number-following'],
      numberFollowers: snapshot['number-followers'],
    );
  }

  List<VideoFeedObject> _mapVideoFeedObject(QuerySnapshot snapshot) {
    List<VideoFeedObject> res = new List();
    snapshot.documents.forEach((document) => res.add(VideoFeedObject(
        author: document['author'],
        videoUrl: document['videoUrl'],
        likes: document['likes'],
        comments: List.from(document['comments']),
        documentId: document.documentID,
        uid: uid)));
    return res;
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
    return userInfoCollection
        .document(uid)
        .snapshots()
        .map(_mapUserData)
        .handleError((e) {
      print(e);
    });
  }

  Stream<List<VideoFeedObject>> getUserFeed() {
    return userInfoCollection
        .document(uid)
        .collection('feeds')
        .snapshots()
        .map(_mapVideoFeedObject);
  }
}
