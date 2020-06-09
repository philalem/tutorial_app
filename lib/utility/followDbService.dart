import 'package:cloud_firestore/cloud_firestore.dart';

class FollowDbService {
  final String uid;
  final CollectionReference followInfoCollection =
      Firestore.instance.collection('follow-info');
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user-info');

  FollowDbService({this.uid});

  Future<void> addToFollowing(String uidToBeFollowed, String name) async {
    await Firestore.instance.runTransaction((transaction) async {
      await userInfoCollection
          .document(uid)
          .updateData({'number-following': FieldValue.increment(1)});
      return followInfoCollection
          .document(uid)
          .collection('following')
          .document(uidToBeFollowed)
          .setData({'uid': uid, 'name': name}).whenComplete(
              () => print("User followed successfully."));
    });
  }

  Future<void> removeFromFollowing(String uidToBeUnFollowed) async {
    await Firestore.instance.runTransaction((transaction) async {
      await userInfoCollection
          .document(uid)
          .updateData({'number-following': FieldValue.increment(-1)});
      return followInfoCollection
          .document(uid)
          .collection('following')
          .document(uidToBeUnFollowed)
          .delete()
          .whenComplete(() => print("User unfollowed successfully."));
    });
  }

  Future<bool> isFollowing(String uidToBeFollowed) async {
    bool isFollowing = false;
    var usersRef = followInfoCollection
        .document(uid)
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
