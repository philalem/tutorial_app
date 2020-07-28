import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/feed/VideoFeedObject.dart';
import 'package:creaid/profile/post.dart';

class ProfilePostsService {
  final String uid;
  final CollectionReference profilePostsCollection =
      Firestore.instance.collection('posts');

  ProfilePostsService({this.uid});

  VideoFeedObject _mapToPost(DocumentSnapshot snapshot) {
    return VideoFeedObject(
      author: snapshot['author'],
      videoUrl: snapshot['videos'][0],
      likes: snapshot['number-likes'],
      documentId: snapshot.documentID,
      title: snapshot['title'],
      description: snapshot['description'],
      thumbnail: snapshot['thumbnail'],
      uid: uid,
    );
  }

  Stream<List<VideoFeedObject>> getProfilePosts() {
    Stream<QuerySnapshot> stream = profilePostsCollection
        .document(uid)
        .collection('user-posts')
        .orderBy('date', descending: true)
        .limit(20)
        .snapshots()
        .handleError((e) {
      print(e);
    });
    return stream.map(
      (snap) => snap.documents.map(_mapToPost).toList(),
    );
  }
}
