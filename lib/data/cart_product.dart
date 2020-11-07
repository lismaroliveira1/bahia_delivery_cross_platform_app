import 'dart:collection';

import 'package:bahia_delivery/data/incremental_optional_data.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  String cId;
  String category;
  String pId;
  int quantify;
  String productImage;
  String storeId;
  double price;
  String productTitle;
  String productDescription;
  double productPrice;
  List<IncrementalOptData> productOptionals = [];
  ProductData productData;
  CartProduct();
  CartProduct.fromDocument(DocumentSnapshot document) {
    //Colocar um laço para verficar de já existe o produto no carrinho
    storeId = document.data["storeId"];
    productImage = document.data["productImage"];
    cId = document.documentID;
    category = document.data["category"];
    pId = document.data["pid"];
    quantify = document.data["quantity"];
    productDescription = document.data["productDescription"];
    productPrice = document.data["productPrice"];
    productTitle = document.data["productTitle"];
    price = document.data["totalPrice"];
    if (document.data["complement"] == "noComplements") {
      productOptionals.clear();
    } else if (document.data["complement"] == []) {
      productOptionals.clear();
    } else {
      List<IncrementalOptData> productOptionalsDocuement = [];
      for (LinkedHashMap p in document.data["complement"]) {
        String id;
        String image;
        String title;
        String description;
        double price;
        String type;
        int maxQuantity;
        int minQuantity;
        String productId;
        String session;
        int quantity = 0;
        p.forEach((key, value) {
          switch (key) {
            case "id":
              id = value;
              break;
            case "title":
              title = value;
              break;
            case "image":
              image = value;
              break;
            case "description":
              description = value;
              break;
            case "price":
              price = value;
              break;
            case "type":
              type = value;
              print(type);
              break;
            case "maxQuantity":
              maxQuantity = value;
              break;
            case "minQuantity":
              minQuantity = value;
              break;
            case "productId":
              productId = value;
              break;
            case "session":
              session = value;
              break;
            case "quantity":
              quantity = value as int;
              break;
          }
        });
        productOptionalsDocuement.add(
          IncrementalOptData(
            id: id,
            productId: productId,
            type: type,
            image: image,
            title: title,
            description: description,
            maxQuantity: maxQuantity,
            minQuantity: minQuantity,
            price: price,
            session: session,
            quantity: quantity,
          ),
        );
      }
      productOptionals = productOptionalsDocuement;
    }
  }

  Map<String, dynamic> toMap() {
    List complementMap = [];
    for (var i = 0; i < productOptionals.length; i++) {
      if (productOptionals[i].quantity > 0) {
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
    }
    return {
      "productImage": productImage,
      "storeId": storeId,
      "productTitle": productTitle,
      "category": category,
      "pid": pId,
      "quantity": quantify,
      "productPrice": productPrice,
      "productDescription": productDescription,
      "totalPrice": price,
      "complement": complementMap.toList(),
    };
  }
}
