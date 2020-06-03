import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsDbService {
  final String uid;
  final CollectionReference notificationsCollection =
      Firestore.instance.collection('notifications');

  NotificationsDbService({this.uid});

  Stream<List<dynamic>> getAllNotifications() {
    Stream<QuerySnapshot> stream = notificationsCollection
        .document(uid)
        .collection('notifications')
        .limit(20)
        .snapshots();
    return stream.map(
      (snap) => snap.documents
          .map(
            (doc) => {
              doc.data['name'],
              doc.data['type'],
              doc.data['comment'],
              doc.data['date'],
            },
          )
          .toList(),
    );
  }
}
