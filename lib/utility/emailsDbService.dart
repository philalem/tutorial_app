import 'package:cloud_firestore/cloud_firestore.dart';

class EmailsDbService {
  final String uid;
  final CollectionReference emailsCollection =
      Firestore.instance.collection('emails');

  EmailsDbService({this.uid});

  Future<void> populateEmail(String email) {
    return emailsCollection
        .document(uid)
        .setData({'email': email}).whenComplete(
            () => print("User email added successfully."));
  }
}
