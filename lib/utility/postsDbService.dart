import 'package:cloud_firestore/cloud_firestore.dart';

class PostsDbService {
  final String uid;
  final CollectionReference postsCollection =
      Firestore.instance.collection('posts');

  PostsDbService({this.uid});

  Future<String> addPostToDb(String title, String description) async {
    print('Adding post information...');
    var date = DateTime.now();
    var postData = {
      'title': title,
      'description': description,
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
    return userRef.documentID;
  }

  Future<void> addMediaInformation(
      String documentId, List<String> videoPaths, String thumbnailPath) async {
    print('Uploading media download links...');
    var postData = {
      'videos': videoPaths,
      'thumbnail': thumbnailPath,
    };
    await postsCollection
        .document(uid)
        .collection("user-posts")
        .document(documentId)
        .setData(postData, merge: true)
        .catchError((e) {
      print("Got error: ${e.error}");
      return 1;
    });
    await postsCollection
        .document(uid)
        .collection("following-posts")
        .document(documentId)
        .setData(postData, merge: true)
        .catchError((e) {
      print("Got error: ${e.error}");
      return 1;
    });
    print('Done.');
  }
}
