import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/emailsDbService.dart';
import 'package:creaid/utility/interestsDbService.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user.dart';

class FireBaseAuthorization {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFireBaseUser);
  }

  Future getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = res.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateUserEmail(String email) async {
    try {
      FirebaseUser user = await getCurrentUser();
      user.updateEmail(email);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateUserName(String name, FirebaseUser user) async {
    var update = UserUpdateInfo();
    update.displayName = name;
    await user.updateProfile(update);
    await user.reload();
  }

  Future registerWithEmailAndPassword(String email, String username,
      String password, String name, List<String> interests) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      var uid = user.uid;
      updateUserName(name, user);
      await Firestore.instance
          .runTransaction((transaction) async {
            EmailsDbService(uid: uid).populateEmail(email);
            UserDbService(uid: uid).updateUserInfo(name, username, 0, 0);
            InterestsDbService(uid: uid).updateInterests(interests);
            return;
          })
          .then((value) => print("The initialize user transaction successful!"))
          .catchError((error) {
            print(
                'The initialize user transaction failed with the following error: ');
            throw (error);
          });
      return _userFromFireBaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
