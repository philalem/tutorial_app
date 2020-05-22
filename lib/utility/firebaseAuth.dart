import 'package:creaid/utility/userDBService.dart';
import 'user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthorization {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(uuid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFireBaseUser);
  }

  Future getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = res.user;
      return user;
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

  Future registerWithEmailAndPassword(String email, String password, String name, List<String> interests) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      updateUserName(name, user);
      UserDbService(uuid: user.uid).updateUserInfo(name, email, password, interests);
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