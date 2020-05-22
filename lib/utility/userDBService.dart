import 'package:cloud_firestore/cloud_firestore.dart';

class UserDbService {
  final String uuid;
  final CollectionReference creaidCollection = Firestore.instance.collection('userInfo');

  UserDbService({this.uuid});

  Future<void> updateUserInfo(String name, String email, String password, List<String> interests) async {
    return await creaidCollection.document(uuid).setData({
      'name': name,
      'email': email,
      'password': password,
      'interests': interests,
    });
  }

}