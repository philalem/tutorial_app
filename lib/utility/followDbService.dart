import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';

class FollowDbService {
  final String uid;
  final CollectionReference followInfoCollection =
      Firestore.instance.collection('follow-info');
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user-info');

  FollowDbService({this.uid});

  Future<void> addToFollowing(String uidToBeFollowed, String name) async {
    print('Uid: $uid');
    print('Uid to be followed: $uidToBeFollowed');
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

  Stream<List<UserData>> getNextSetOfFollowers() {
    Stream<QuerySnapshot> stream = followInfoCollection
        .document(uid)
        .collection('followers')
        .limit(20)
        .snapshots();
    return stream.map(
      (snap) => snap.documents.map(_mapToObject).toList(),
    );
  }

  UserData _mapToObject(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot['uid'],
      name: snapshot['name'],
      photoUrl: snapshot['photo-url'],
    );
  }

  Stream<List<UserData>> getNextSetOfFollowing() {
    Stream<QuerySnapshot> stream = followInfoCollection
        .document(uid)
        .collection('following')
        .limit(20)
        .snapshots();
    return stream.map(
      (snap) => snap.documents.map(_mapToObject).toList(),
    );
  }
}
