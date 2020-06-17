import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/feed/FeedCommentObject.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/feed/VideoFeedObject.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDbService {
  final String uid;
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user-info');
  final CollectionReference feedInfoCollection =
      Firestore.instance.collection('posts');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDbService({this.uid});

  Future<void> updateUserInfo(String name, String username, int numberFollowing,
      int numberFollowers) async {
    return await userInfoCollection.document(uid).setData({
      'name': name,
      'username': username,
      'number-following': numberFollowing,
      'number-followers': numberFollowers,
    });
  }

  UserData _mapUserData(DocumentSnapshot snapshot) {
    return UserData(
        username: snapshot['username'],
        name: snapshot['name'],
        photoUrl: snapshot['photo-url'],
        numberFollowing: snapshot['number-following'],
        numberFollowers: snapshot['number-followers'],
        feedId: snapshot['feed-id']);
  }

  VideoFeedObject _mapSingleVideoFeedObject(DocumentSnapshot snapshot) {
    return VideoFeedObject(
      likes: snapshot['likes']
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
          uid: uid,
        )));
    return res;
  }

  List<FeedCommentObject> _mapFeedCommentObject(QuerySnapshot snapshot) {
    List<FeedCommentObject> res = new List();

    snapshot.documents.forEach(
        (comment) => res.add(FeedCommentObject(comment: comment['comment'], name: comment['name'])));

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
    return feedInfoCollection
        .document(feedId)
        .collection('following-posts')
        .snapshots()
        .map(_mapVideoFeedObject);
  }

  Stream<List<FeedCommentObject>> getFeedComments(
      String videoId, String feedId) {
    return feedInfoCollection
        .document(feedId)
        .collection('following-posts')
        .document(videoId)
        .collection('comments')
        .snapshots()
        .map(_mapFeedCommentObject);
  }

  addComment(String videoId, String feedId, String comment, String author) async {
    await feedInfoCollection
        .document(feedId)
        .collection('following-posts')
        .document(videoId)
        .collection('comments')
        .add({'comment': comment, 'name' : author, 'uid' : uid});
  }

  addLike(String videoId, String feedId, String author) async {
    final likeDocument = await feedInfoCollection.document(feedId).collection('following-posts').document(videoId).collection('liked').document(uid).get();

    if (likeDocument == null || !likeDocument.exists) {
      await feedInfoCollection.document(feedId).collection('following-posts').document(videoId).collection('liked').document(uid).setData({'liker-id' : uid, "name" : author});
      await feedInfoCollection.document(feedId).collection('following-posts').document(videoId).updateData({'likes' : FieldValue.increment(1)});
    }
  }

  Stream<VideoFeedObject> getVideo(String feedId, String videoId) {
    return feedInfoCollection.document(feedId).collection('following-posts').document(videoId).snapshots().map(_mapSingleVideoFeedObject);
  }

}
