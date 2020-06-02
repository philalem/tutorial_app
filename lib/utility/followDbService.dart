import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowDbService {
  final String uid;
  final CollectionReference followInfoCollection =
      Firestore.instance.collection('follow-info');

  FollowDbService({this.uid});

  Future<void> addToFollowing(String uidToBeFollowed) async {
    await followInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(1)});
    return followInfoCollection
        .document(uid)
        .collection('following')
        .document(uidToBeFollowed)
        .setData({'uid': uidToBeFollowed}).whenComplete(
            () => print("User followed successfully."));
  }

  Future<void> removeFromFollowing(String uidToBeUnFollowed) async {
    await followInfoCollection
        .document(uid)
        .updateData({'number-following': FieldValue.increment(-1)});
    return followInfoCollection
        .document(this.uid)
        .collection('following')
        .document(uidToBeUnFollowed)
        .delete()
        .whenComplete(() => print("User unfollowed successfully."));
  }

  Future<bool> isFollowing(String uidToBeFollowed) async {
    bool isFollowing = false;
    var usersRef = followInfoCollection
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
}
