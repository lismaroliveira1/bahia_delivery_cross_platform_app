import 'package:bahia_delivery/data/incremental_optional_data.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  String cId;
  String category;
  String pId;
  int quantify;
  String storeId;
  double price;
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

  Map<dynamic, dynamic> toComplementMap() {
    var complementMap = {};
    productOptionals.forEach((complement) {
      complementMap["id"] = complement.id;
      complementMap["image"] = complement.image;
    });
    return complementMap;
  }

  Map<String, dynamic> toMap() {
    List complementMap = [];
    for (var i = 0; i < productOptionals.length; i++) {
      complementMap.add({
        "id": productOptionals[i].id,
        "image": productOptionals[i].image,
        "title": productOptionals[i].title,
        "price": productOptionals[i].price,
        "description": productOptionals[i].description,
        "productId": productOptionals[i].productId,
        "quantity": productOptionals[i].quantity,
      });
    }
    return {
      "storeId": storeId,
      "category": category,
      "pid": pId,
      "quantity": quantify,
      "price": price,
      "product": productData.toResumedMap(),
      "complement": FieldValue.arrayUnion(complementMap),
    };
  }
}
