import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/notifications/notification.dart';

class NotificationsDbService {
  final String uid;
  final CollectionReference notificationsCollection =
      Firestore.instance.collection('notifications');

  NotificationsDbService({this.uid});

  Notification _mapToNotification(DocumentSnapshot snapshot) {
    return Notification(
      name: snapshot['name'],
      type: snapshot['type'],
      comment: snapshot['comment'],
      date: snapshot['date'].toDate(),
    );
  }

  Stream<List<Notification>> getAllNotifications() {
    Stream<QuerySnapshot> stream = notificationsCollection
        .document(uid)
        .collection('notifications')
        .limit(20)
        .snapshots();
    return stream.map(
      (snap) => snap.documents.map(_mapToNotification).toList(),
    );
  }
}
