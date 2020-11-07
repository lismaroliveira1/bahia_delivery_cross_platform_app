import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class IncrementalOptData {
  String id;
  String image;
  String title;
  String description;
  double price;
  String type;
  int maxQuantity;
  int minQuantity;
  String productId;
  String session;
  int quantity = 0;

  IncrementalOptData({
    this.id,
    @required this.productId,
    @required this.type,
    @required this.image,
    @required this.title,
    @required this.description,
    @required this.maxQuantity,
    @required this.minQuantity,
    @required this.price,
    @required this.session,
    this.quantity,
  });
  IncrementalOptData.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    image = documentSnapshot.data["image"];
    title = documentSnapshot.data["title"];
    description = documentSnapshot.data["description"];
    price = documentSnapshot.data["price"];
    maxQuantity = documentSnapshot.data["maxQuantity"];
    minQuantity = documentSnapshot.data["minQuantity"];
    productId = documentSnapshot.data["productId"];
    type = documentSnapshot.data["type"];
    session = documentSnapshot.data["session"];
  }
  Map<String, dynamic> toIncrementalMap() {
    return {
      "image": image,
      "title": title,
      "description": description,
      "price": price,
      "maxQuantity": maxQuantity,
      "minQuantity": minQuantity,
      "type": type,
      "productId": productId,
      "session": session,
      'updateAt': FieldValue.serverTimestamp(),
    };
  }
}
