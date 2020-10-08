import 'package:bahia_delivery/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class StoreModel extends Model {
  UserModel user;
  bool isPartner = false;
  static StoreModel of(BuildContext context) =>
      ScopedModel.of<StoreModel>(context);
  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
  }

  Future<void> getPartenerStatus() async {
    DocumentSnapshot docUser = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .get();
    if (docUser.data["isPartner"] == true) {
      isPartner = true;
    } else {
      isPartner = false;
    }
  }

  void createNewStoreWithCNPJ() {}
}
