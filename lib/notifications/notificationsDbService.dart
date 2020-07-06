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
      photoUrl: snapshot['photoUrl'],
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

  sendShareVideoNotification(String name) async {
    await notificationsCollection
        .document(uid)
        .updateData({'new-notifications': FieldValue.increment(1)});
    await notificationsCollection
        .document(uid)
        .collection('notifications')
        .add({
      'comment': name + ' wanted to share a video with you',
      'date': new DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'type': 'Video Share',
      'uid': uid
    });
  }
}
