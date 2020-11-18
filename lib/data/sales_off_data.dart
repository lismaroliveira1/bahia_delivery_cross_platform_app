import 'dart:io';

import 'package:bahia_delivery/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesOffData {
  String id;
  String title;
  String image;
  File imageFile;
  String description;
  int quantity;
  List<ProductData> products = [];

  SalesOffData(
    this.id,
    this.title,
    this.image,
    this.imageFile,
    this.description,
    this.quantity,
  );

  SalesOffData.fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    title = doc.data["title"];
    image = doc.data["image"];
    description = doc.data["description"];
    quantity = doc.data["quantity"];
  }
}
