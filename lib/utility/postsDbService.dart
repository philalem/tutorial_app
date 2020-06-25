import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostsDbService {
  final String uid;
  final CollectionReference postsCollection =
      Firestore.instance.collection('posts');

  PostsDbService({this.uid});

  Future<void> addPostToDb(
      String title, String description, List<String> videoPaths) async {
    print('Adding post information...');
    var date = DateTime.now();
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPaths[0],
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    var postData = {
      'title': title,
      'description': description,
      'videos': videoPaths,
      'number-likes': 0,
      'thumbnail': thumbnail,
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
