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
      videos: snapshot['videos'],
      thumbnail: snapshot['thumbnail'],
    );
  }

  Future<List<Post>> getExplorePosts() async {
    QuerySnapshot posts = await exploreCollection
        .orderBy('date', descending: true)
        .limit(20)
        .getDocuments()
        .catchError((e) {
      print(e);
    });
    return posts.documents
        .map(
          (snap) => _mapToPost(snap),
        )
        .toList();
  }
}
