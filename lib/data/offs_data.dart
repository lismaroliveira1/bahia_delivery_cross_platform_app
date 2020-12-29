import 'dart:io';

import 'package:bd_app_full/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OffData {
  String id;
  String description;
  String image;
  String title;
  ProductData productData;
  File imageFile;
  double discountPercentage = 0;
  int quantity = 1;
  double price = 0;
  String storeId;

  OffData(
      {@required this.description,
      @required this.image,
      @required this.title,
      @required this.productData,
      @required this.imageFile,
      this.id,
      this.discountPercentage,
      this.quantity,
      this.price,
      this.storeId});

  OffData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    description = queryDoc.get("description");
    image = queryDoc.get("image");
    title = queryDoc.get("title");
    discountPercentage = queryDoc.get("discount");
    productData = ProductData.fromLindedHasMapForPartner(
      queryDoc.get("product"),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "discount": discountPercentage,
      'image': image,
      "title": title,
      "product": productData.toMap(),
    };
  }

  Map<String, dynamic> toOffCartMap() {
    return {
      "type": "off",
      "comboImage": image,
      "storeId": storeId,
      "comboTitle": title,
      "quantity": quantity,
      "price": price,
      "description": description,
    };
  }
}
