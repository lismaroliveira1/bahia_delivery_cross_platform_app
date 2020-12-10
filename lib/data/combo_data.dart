import 'dart:collection';
import 'dart:io';

import 'package:bd_app_full/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ComboData {
  String id;
  String image;
  String title;
  String description;
  double discountPercentage;
  double discountCoin;
  int quantity;
  double price;
  String storeId;
  List<ProductData> products = [];
  File imageFile;

  ComboData({
    @required this.image,
    @required this.title,
    @required this.description,
    @required this.discountPercentage,
    @required this.discountCoin,
    @required this.products,
    this.id,
    this.quantity,
    this.price,
    this.storeId,
  });
  ComboData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    title = queryDoc.get("title");
    description = queryDoc.get("description");
    discountPercentage = queryDoc.get("discountPercentage");
    discountCoin = queryDoc.get("discountCoin");
    image = queryDoc.get("image");
    for (LinkedHashMap linkedArray in queryDoc.get("products")) {
      products.add(ProductData.fromLinkedHashMap(linkedArray));
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "image": image,
      "title": title,
      "description": description,
      "discountPercentage": discountPercentage,
      "discountCoin": discountCoin,
      "products": products.map((productData) {
        return {
          "pId": productData.pId,
          "categoryId": productData.categoryId,
          "category": productData.category,
          "productDescription": productData.productDescription,
          "productImage": productData.productImage,
          "group": productData.group,
          "productPrice": productData.productPrice,
          "storeId": productData.storeId,
          "productTitle": productData.productTitle,
          "quantity": 0,
          "complement": "noComplement",
        };
      }).toList(),
    };
  }

  Map<String, dynamic> toComboProductMap() {
    return {
      "type": "combo",
      "comboImage": image,
      "storeId": storeId,
      "comboTitle": title,
      "quantity": quantity,
      "price": price,
    };
  }
}
