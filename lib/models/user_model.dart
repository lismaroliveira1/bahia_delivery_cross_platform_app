import 'package:bahia_delivery/helpers/firebase_errors.dart';
import 'package:bahia_delivery/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  Map<String, dynamic> userData = Map();
  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    try {
      final AuthResult result = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      this.firebaseUser = result.user;
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
  }

  Future<void> signUp(
      {@required User user,
      @required Function onSuccess,
      @required Function onFail}) async {
    isLoading = true;
    notifyListeners();
    try {
      final AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      this.firebaseUser = result.user;
      await _saveUserData(user);
      onSuccess();
      isLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _saveUserData(User user) async {
    userData["name"] = user.name;
    userData["email"] = user.email;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }
}
