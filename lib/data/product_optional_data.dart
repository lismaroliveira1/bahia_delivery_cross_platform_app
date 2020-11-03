import 'package:cloud_firestore/cloud_firestore.dart';

class OptionalProductData {
  String title;
  String id;
  double price;
  int quantity;
  int maxQuantity;

  OptionalProductData.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    title = documentSnapshot.data["title"];
    price = documentSnapshot.data["price"];
    maxQuantity = documentSnapshot.data["maxQuantity"];
    quantity = 1;
  }
}
