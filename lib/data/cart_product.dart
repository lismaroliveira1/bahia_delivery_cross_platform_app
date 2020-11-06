import 'package:bahia_delivery/data/incremental_optional_data.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  String cId;
  String category;
  String pId;
  int quantify;
  String storeId;
  List<IncrementalOptData> productOptionals = [];

  ProductData productData;
  CartProduct();
  CartProduct.fromDocument(DocumentSnapshot document) {
    //Colocar um laço para verficar de já existe o produto no carrinho
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
      "product": productData.toResumedMap(),
    };
  }
}
