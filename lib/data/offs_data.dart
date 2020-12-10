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

  OffData({
    @required this.description,
    @required this.image,
    @required this.title,
    @required this.productData,
    @required this.imageFile,
    this.id,
  });

  OffData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    description = queryDoc.get("description");
    image = queryDoc.get("image");
    title = queryDoc.get("title");
    productData = ProductData.fromLindedHasMapForPartner(
      queryDoc.get("product"),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      'image': image,
      "title": title,
      "product": productData.toMap(),
    };
  }
}
