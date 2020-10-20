import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String title;
  String category;
  String image;
  double price;
  String description;
  String fullDescription;

  ProductData(
    this.id,
    this.title,
    this.category,
    this.description,
    this.image,
    this.price,
    this.fullDescription,
  );
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    category = snapshot.data["category"];
    image = snapshot.data["image"];
    price = snapshot.data["price"];
    description = snapshot.data["description"];
    fullDescription = snapshot.data["fullDescription"];
  }
  Map<String, dynamic> toResumedMap() {
    return {"title": title, "description": description, "price": price};
  }
}
