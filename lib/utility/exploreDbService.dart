import 'package:cloud_firestore/cloud_firestore.dart';

class ExploreDbService {
  final String uid;
  final CollectionReference exploreCollection =
      Firestore.instance.collection('explore');

  ExploreDbService({this.uid});
}
