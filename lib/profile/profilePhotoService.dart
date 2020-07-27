import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePhotoService {
  final String uid;
  final CollectionReference profilePhotosCollection =
      Firestore.instance.collection('profile-photos');
  final CollectionReference userInfoCollection =
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
      print('Something went wrong while getting the profile picture.');
      print(e);
    });
  }

  Future uploadPhotoToCloudStore(File image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('profilePictures/${image.path}}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    return await storageReference.getDownloadURL();
  }
}
