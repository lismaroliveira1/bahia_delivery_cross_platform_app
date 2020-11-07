import 'dart:collection';
import 'package:bahia_delivery/data/incremental_optional_data.dart';
import 'package:flutter/material.dart';

class ProductOrderData {
  String category;
  List<IncrementalOptData> optnalsComplement = [];
  String id;
  String productDescription;
  double productPrice;
  String productTitle;
  int quantity;
  String storeId;
  double totalPrice;
  ProductOrderData({
    @required this.category,
    @required this.id,
    @required this.optnalsComplement,
    @required this.productDescription,
    @required this.productPrice,
    @required this.productTitle,
    @required this.quantity,
    @required this.storeId,
    @required this.totalPrice,
  });
  ProductOrderData.fromDynamicDocument(dynamic documentSnapshot) {
    category = documentSnapshot["category"];
    id = documentSnapshot["pid"];
    productDescription = documentSnapshot["productDescrition"];
    productPrice = documentSnapshot["productPrice"];
    productTitle = documentSnapshot["productTitle"];
    storeId = documentSnapshot["storeId"];
    quantity = documentSnapshot["quantity"];
    totalPrice = documentSnapshot["totalPrice"];

    if (documentSnapshot["complement"] == "noComplements") {
      optnalsComplement.clear();
    } else if (documentSnapshot["complement"] == []) {
      optnalsComplement.clear();
    } else {
      List<IncrementalOptData> productOptionalsDocuement = [];
      for (LinkedHashMap p in documentSnapshot["complement"]) {
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
      optnalsComplement = productOptionalsDocuement;
    }
  }
}
