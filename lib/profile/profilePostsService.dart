import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/profile/post.dart';

class ProfilePostsService {
  final String uid;
  final CollectionReference profilePostsCollection =
      Firestore.instance.collection('posts');

  ProfilePostsService({this.uid});

  Post _mapToPost(DocumentSnapshot snapshot) {
    return Post(
      id: snapshot.documentID,
      thumbnail: snapshot['thumbnail'],
    );
  }

  Stream<List<Post>> getProfilePosts() {
    Stream<QuerySnapshot> stream = profilePostsCollection
        .document(uid)
        .collection('user-posts')
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
