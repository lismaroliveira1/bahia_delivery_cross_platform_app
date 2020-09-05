import 'package:bahia_delivery/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  String cId;
  String category;
  String pId;
  int quantify;
  String storeId;

  ProductData productData;
  CartProduct();
  CartProduct.fromDocument(DocumentSnapshot document) {
    storeId = document.data["storeId"];
    cId = document.documentID;
    category = document.data["category"];
    pId = document.data["pid"];
    quantify = document.data["quantity"];
  }
  Map<String, dynamic> toMap() {
    return {
      "storeId": storeId,
      "category": category,
      "pid": pId,
      "quantity": quantify,
      //"product": productData.toResumedMap(),
    };
  }
}
