import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class IncrementalOptData {
  String image;
  String title;
  String description;
  double price;
  String type;
  int maxQuantity;
  int minQuantity;

  IncrementalOptData({
    @required this.image,
    @required this.title,
    @required this.description,
    @required this.maxQuantity,
    @required this.minQuantity,
    @required this.price,
  });
  IncrementalOptData.fromDocument(DocumentSnapshot documentSnapshot) {
    image = documentSnapshot.data["image"];
    title = documentSnapshot.data["title"];
    description = documentSnapshot.data["description"];
    price = documentSnapshot.data["price"];
    maxQuantity = documentSnapshot.data["maxQuantity"];
    minQuantity = documentSnapshot.data["minQuantity"];
  }
  Map<String, dynamic> toIncrementalMap() {
    return {
      "image": image,
      "title": title,
      "description": description,
      "price": price,
      "maxQuantity": maxQuantity,
      "minQuantity": minQuantity,
    };
  }
}
