import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/FeedCommentObject.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/VideoFeedObject.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDbService {
  final String uid;
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user-info');
  final CollectionReference feedInfoCollection =
    Firestore.instance.collection('posts');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDbService({this.uid});

  Future<void> updateUserInfo(
      String name,
      String username,
      String email,
      String password,
      List<String> interests,
      int numberFollowing,
      int numberFollowers) async {
    return await userInfoCollection.document(uid).setData({
      'name': name,
      'username': username,
      'email': email,
      'interests': interests,
      'photo-url': 'https://firebasestorage.googleapis.com/v0/b/creaid-b4528.appspot.com/o/unknown-profile.png?alt=media&token=36b3cb28-743c-4352-ad53-32ec67387e0d',
      'number-following': numberFollowing,
      'number-followers': numberFollowers,
    });
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    DocumentReference ref = userInfoCollection.document(uid);
    ref.updateData({"photo-url": photoUrl});
  }

  Future<void> addToFollowing(String uidToBeFollowed) async {
    await userInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(1)});
    return userInfoCollection
        .document(uid)
        .collection('following')
        .document(uidToBeFollowed)
        .setData({'uid': uidToBeFollowed}).whenComplete(
            () => print("User followed successfully."));
  }

  Future<void> removeFromFollowing(String uidToBeUnFollowed) async {
    await userInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(-1)});
    return userInfoCollection
        .document(this.uid)
        .collection('following')
        .document(uidToBeUnFollowed)
        .delete()
        .whenComplete(() => print("User unfollowed successfully."));
  }

  Future<bool> isFollowing(String uidToBeFollowed) async {
    bool isFollowing = false;
    var usersRef = userInfoCollection
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
      //email: snapshot['email'],
      name: snapshot['name'],
      //interests: List.from(snapshot['interests']),
      photoUrl: snapshot['photo-url'],
      numberFollowing: snapshot['number-following'],
      numberFollowers: snapshot['number-followers'],
      feedId: snapshot['feed-id']
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
            uid: uid,
          )
        )
      );
    return res;
  }

  List<FeedCommentObject> _mapFeedCommentObject(QuerySnapshot snapshot) {
    List<FeedCommentObject> res = new List();

    snapshot.documents.forEach((comment) =>
      res.add(
        FeedCommentObject(
          comment: comment['comment']
        )
      )
    );

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

  Stream<List<VideoFeedObject>> getUserFeed(String feedId) {
    return feedInfoCollection.document(feedId).collection('following-posts').snapshots().map(_mapVideoFeedObject);
  }

  Stream<List<FeedCommentObject>> getFeedComments(String videoId, String feedId) {
    return feedInfoCollection.document(feedId).collection('following-posts').document(videoId).collection('comments').snapshots().map(_mapFeedCommentObject);
  }

  addComment(String videoId, String feedId, String comment) async {
    await feedInfoCollection.document(feedId).collection('following-posts').document(videoId).collection('comments').add({
      'comment' : comment
    });
  }
}
