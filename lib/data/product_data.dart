import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String title;
  String category;
  String image;
  double price;
  String description;
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    category = snapshot.data["category"];
    image = snapshot.data["image"];
    price = snapshot.data["price"];
    description = snapshot.data["description"];
  }
  Map<String, dynamic> toResumedMap() {
    return {"title": title, "description": description, "price": price};
  }
}
