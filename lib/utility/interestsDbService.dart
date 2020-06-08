import 'package:cloud_firestore/cloud_firestore.dart';

class InterestsDbService {
  final String uid;
  final CollectionReference interestsCollection =
      Firestore.instance.collection('interests');

  InterestsDbService({this.uid});

  Future<void> updateInterests(List<String> interests) async {
    return interestsCollection
        .document(uid)
        .setData({'interests': interests}).whenComplete(
            () => print("Added $interests successfully."));
  }

  Stream<List<String>> getAllInterests() {
    return interestsCollection
        .document(uid)
        .snapshots()
        .map(_mapInterestsToList);
  }

  List<String> _mapInterestsToList(DocumentSnapshot snapshot) {
    return List.from(snapshot['interests']);
  }
}
