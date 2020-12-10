import 'dart:collection';

import 'package:bd_app_full/data/complement_data.dart';
import 'package:bd_app_full/data/incremental_options_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductData {
  String category;
  String categoryId;
  String pId;
  String productDescription;
  String fullDescription;
  String productImage;
  double productPrice;
  int quantity;
  String productTitle;
  String group;
  String storeId;
  double totalPrice;
  List<ComplementData> complementProducts = [];
  List<IncrementalOptionalsData> incrementalOptionalsList = [];
  ProductData({
    @required this.category,
    @required this.categoryId,
    @required this.pId,
    @required this.productDescription,
    @required this.fullDescription,
    @required this.productImage,
    @required this.productPrice,
    @required this.quantity,
    @required this.productTitle,
    @required this.group,
    @required this.complementProducts,
    @required this.incrementalOptionalsList,
    @required this.storeId,
    @required this.totalPrice,
  });
  ProductData.fromLinkedHashMap(LinkedHashMap hashDoc) {
    pId = hashDoc["pid"];
    category = hashDoc["category"];
    categoryId = hashDoc["categoryId"];
    productDescription = hashDoc["productDescription"];
    productImage = hashDoc["productImage"];
    productPrice = hashDoc["productPrice"];
    quantity = hashDoc["quantity"];
    productTitle = hashDoc["productTitle"];
    storeId = hashDoc["storeId"];
    totalPrice = hashDoc["totalPrice"];
    try {
      for (LinkedHashMap linkedHashMap in hashDoc["complement"]) {
        complementProducts.add(ComplementData.fromLinkedHashMap(linkedHashMap));
      }
    } catch (erro) {}
  }

  ProductData.fromLindedHasMapForPartner(LinkedHashMap hashDoc) {
    category = hashDoc["category"];
    categoryId = hashDoc["categoryId"];
    productDescription = hashDoc["description"];
    productImage = hashDoc["image"];
    productPrice = hashDoc["price"];
    productTitle = hashDoc["title"];
    storeId = hashDoc["storeID"];
    totalPrice = hashDoc["price"];
  }

  ProductData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    pId = queryDoc.id;
    category = queryDoc.get("category");
    categoryId = queryDoc.get("categoryId");
    productDescription = queryDoc.get("description");
    fullDescription = queryDoc.get("fullDescription");
    group = queryDoc.get("group");
    productImage = queryDoc.get("image");
    productPrice = queryDoc.get("price");
    storeId = queryDoc.get("storeID");
    productTitle = queryDoc.get("title");
  }
  Map<String, dynamic> toMap() {
    return {
      "categoryId": categoryId,
      "category": category,
      "description": productDescription,
      "fullDescription": fullDescription,
      "image": productImage,
      "group": group,
      "price": productPrice,
      "storeID": storeId,
      "title": productTitle,
    };
  }
}
