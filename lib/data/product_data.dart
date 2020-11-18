import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductData {
  String id;
  String title;
  String categoryId;
  String image;
  double price;
  String description;
  String fullDescription;
  String group;
  String storeId;

  ProductData({
    @required this.id,
    @required this.title,
    @required this.categoryId,
    @required this.description,
    @required this.image,
    @required this.price,
    @required this.fullDescription,
    @required this.group,
    this.storeId,
  });
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    categoryId = snapshot.data["categoryId"];
    image = snapshot.data["image"];
    price = snapshot.data["price"];
    description = snapshot.data["description"];
    fullDescription = snapshot.data["fullDescription"];
    group = snapshot.data["group"];
  }
  Map<String, dynamic> toResumedMap() {
    return {"title": title, "description": description, "price": price};
  }
}
