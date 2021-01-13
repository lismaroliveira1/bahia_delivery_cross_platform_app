import 'dart:collection';

import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/incremental_options_data.dart';
import 'package:bd_app_full/data/product_data.dart';
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
  List<IncrementalOptionalsData> productOptionals = [];
  ProductData productData;
  ComboData comboProductData;
  CartProduct();
  CartProduct.fromDocument(QueryDocumentSnapshot document) {
    //Colocar um laço para verficar de já existe o produto no carrinho
    storeId = document.get("storeId");
    productImage = document.get("productImage");
    cId = document.id;
    category = document.get("category");
    pId = document.get("pid");
    quantify = document.get("quantity");
    productDescription = document.get("productDescription");
    productPrice = document.get("productPrice");
    productTitle = document.get("productTitle");
    price = document.get("totalPrice");
    if (document.get("complement") == "noComplements") {
      productOptionals.clear();
    } else if (document.get("complement") == []) {
      productOptionals.clear();
    } else {
      List<IncrementalOptionalsData> productOptionalsDocuement = [];
      for (LinkedHashMap p in document.get("complement")) {
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
          IncrementalOptionalsData(
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
      "type": "product",
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
      "createdAt": DateTime.now(),
    };
  }
}
