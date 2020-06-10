import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePhotoService {
  final String uid;
  final CollectionReference profilePhotosCollection =
      Firestore.instance.collection('profile-photos');

  ProfilePhotoService({this.uid});

  Future<void> uploadPhoto(String pathToPhoto) {
    return profilePhotosCollection
        .document(uid)
        .setData({'original': pathToPhoto}).whenComplete(
            () => print("User photo added successfully."));
  }

  Stream<dynamic> getProfilePhoto() {
    return profilePhotosCollection
        .document(uid)
        .snapshots()
        .map((snapshot) => snapshot['original'])
        .handleError((e) {
      print(e);
    });
  }
}
