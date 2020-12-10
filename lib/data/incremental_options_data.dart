import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncrementalOptionalsData {
  String id;
  String description;
  String image;
  int maxQuantity;
  int minQuantity;
  double price;
  String productId;
  String session;
  String title;
  String type;
  int quantity = 0;

  IncrementalOptionalsData({
    @required this.id,
    @required this.productId,
    @required this.type,
    @required this.image,
    @required this.title,
    @required this.description,
    @required this.maxQuantity,
    @required this.minQuantity,
    @required this.price,
    @required this.session,
    @required this.quantity,
  });
  IncrementalOptionalsData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    description = queryDoc.get("description");
    image = queryDoc.get("image");
    maxQuantity = queryDoc.get("maxQuantity");
    minQuantity = queryDoc.get("minQuantity");
    price = queryDoc.get("price");
    productId = queryDoc.get("productId");
    session = queryDoc.get("session");
    title = queryDoc.get("title");
    type = queryDoc.get("type");
  }

  IncrementalOptionalsData.fromDynaminData(dynamic data) {
    id = data.id;
    description = data.description;
    image = data.image;
    maxQuantity = data.maxQuantity;
    minQuantity = data.minQuantity;
    price = data.price;
    productId = data.productId;
    session = data.session;
    title = data.title;
    type = data.type;
    quantity = 0;
  }
}
