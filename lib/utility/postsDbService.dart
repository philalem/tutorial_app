import 'package:cloud_firestore/cloud_firestore.dart';

class PostsDbService {
  final String uid;
  final CollectionReference postsCollection =
      Firestore.instance.collection('posts');

  PostsDbService({this.uid});

  Future<void> addPostToDb(String title, String description,
      List<String> videoPaths, String thumbnail) async {
    print('Adding post information...');
    var date = DateTime.now();
    var postData = {
      'title': title,
      'description': description,
      'videos': videoPaths,
      'thumbnail': thumbnail,
      'number-likes': 0,
      'date': date,
    };
    DocumentReference userRef = await postsCollection
        .document(uid)
        .collection("user-posts")
        .add(postData)
        .catchError((e) {
      print("Got error: ${e.error}");
      return 1;
    });
    await postsCollection
        .document(uid)
        .collection("following-posts")
        .document(userRef.documentID)
        .setData(postData)
        .catchError((e) {
      print("Got error: ${e.error}");
      return 1;
    });
    print("Document ID: " + userRef.documentID);
    print('Done.');
  }
}
