import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/profile/post.dart';

class ExploreDbService {
  final String uid;
  final CollectionReference exploreCollection =
      Firestore.instance.collection('explore');

  ExploreDbService({this.uid});

  Post _mapToPost(DocumentSnapshot snapshot) {
    return Post(
      id: snapshot.documentID,
      thumbnail: snapshot['thumbnail'],
    );
  }

  Stream<List<Post>> getExplorePosts() {
    Stream<QuerySnapshot> stream = exploreCollection
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
