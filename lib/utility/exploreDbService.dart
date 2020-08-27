import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/feed/VideoFeedObject.dart';

class ExploreDbService {
  final String uid;
  final CollectionReference exploreCollection =
      Firestore.instance.collection('explore');

  ExploreDbService({this.uid});

  VideoFeedObject _mapToPost(DocumentSnapshot snapshot) {
    return VideoFeedObject(
      author: snapshot['author'],
      videoUrls: snapshot['videos'],
      likes: snapshot['number-likes'],
      documentId: snapshot.documentID,
      title: snapshot['title'],
      description: snapshot['description'],
      thumbnail: snapshot['thumbnail'],
      uid: uid,
    );
  }

  Future<List<VideoFeedObject>> getExplorePosts() async {
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
