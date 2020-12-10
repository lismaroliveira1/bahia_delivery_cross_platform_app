import 'dart:collection';

import 'package:bd_app_full/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  String id;
  String storeName;
  String client;
  String clientAdrress;
  String clientImage;
  String clientName;
  Timestamp createdAt;
  double discount;
  String paymentType;
  double shipPrice;
  int status;
  String storeDescription;
  String storeId;
  String storeImage;
  double totalPrice;
  List<ProductData> products = [];

  OrderData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    storeName = queryDoc.get("StoreName");
    client = queryDoc.get("client");
    clientAdrress = queryDoc.get("clientAddress");
    clientImage = queryDoc.get("clientImage");
    clientName = queryDoc.get("clientName");
    createdAt = queryDoc.get("createdAt");
    discount = queryDoc.get("discount");
    paymentType = queryDoc.get("paymentType");
    shipPrice = queryDoc.get("shipPrice");
    status = queryDoc.get("status");
    storeDescription = queryDoc.get("storeDescription");
    storeId = queryDoc.get("storeId");
    storeImage = queryDoc.get("storeImage");
    totalPrice = queryDoc.get("totalPrice");
    for (LinkedHashMap p in queryDoc.data()["products"]) {
      products.add(ProductData.fromLinkedHashMap(p));
    }
  }
}
