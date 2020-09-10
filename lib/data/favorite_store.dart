import 'package:bahia_delivery/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteStore {
  UserModel user;
  addFavoriteStoreItem(String storeId) async {
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("favorites")
        .document("stores")
        .collection("stores")
        .document(storeId)
        .setData({"storeId": storeId, "order": 0});
  }
}
