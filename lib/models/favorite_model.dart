import 'package:bahia_delivery/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoriteModel extends Model {
  UserModel user;
  bool isLoading = false;
  bool contains = false;
  static FavoriteModel of(BuildContext context) =>
      ScopedModel.of<FavoriteModel>(context);
  FavoriteModel(this.user);
  void addFavoriteStoreItem(String storeId) async {
    isLoading = true;

    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("favorites")
        .document(storeId)
        .setData({"storeId": storeId, "status": 1});
    isLoading = false;
    notifyListeners();
    print(storeId);
  }

  void deleteFavoriteStoreItem(String storeId) async {
    isLoading = true;
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("favorites")
        .document(storeId)
        .delete();
    isLoading = false;
    notifyListeners();
    print(storeId);
  }

  Future<bool> verifyCartItem(String storeId) async {
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("favorites")
        .getDocuments()
        .then((value) {
      for (DocumentSnapshot doc in value.documents) {
        print(doc.data["storeId"]);
        if (doc.data["storeId"] == storeId) {
          contains = true;
        } else {
          contains = false;
        }
      }
    });
    return contains != null;
  }
}
