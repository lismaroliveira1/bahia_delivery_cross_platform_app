import 'package:bahia_delivery/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  Map<String, dynamic> userData = Map();
  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isPartner = false;
  double longittude;
  double latitude;
  int favoriteStoryQuantity = 0;
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
    _getCurrentLocation();
  }

  Future<void> signIn(
      {@required String email,
      @required String pass,
      @required Function onFail,
      @required Function onSuccess}) async {
    isLoading = true;
    notifyListeners();
    try {
      final AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      this.firebaseUser = result.user;
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    } on PlatformException catch (_) {
      onFail();
      isLoading = false;
      notifyListeners();
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
    } on PlatformException catch (_) {
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
    userData["isPartner"] = user.isPartner;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  bool updateUser() {
    return isPartner;
  }

  void _getCurrentLocation() async {
    final postition =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    longittude = postition.longitude;
    latitude = postition.latitude;
    notifyListeners();
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
        isPartner = userData["isPartner"];
      }
    }
    notifyListeners();
  }
}
