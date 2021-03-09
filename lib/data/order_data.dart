import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';

import '../data/data.dart';

class OrderData {
  String id;
  String storeName;
  String client;
  String clientAddress;
  String clientAddressId;
  double clientLat;
  double clientLng;
  String clientImage;
  String clientName;
  Timestamp createdAt;
  double discount;
  String paymentType;
  double shipPrice;
  int status;
  String storeDescription;
  String storeId;
  String storeAddress;
  String storeAdressId;
  double storeLat;
  double storeLng;
  String storeImage;
  double totalPrice;
  List<ProductData> products = [];
  List<ComboData> combos = [];
  String vehicleType;
  DeliveryManData deliveryManData;
  String paymentOnAppType;
  String paymentInfo;
  String deliveryManString = '';
  bool isChoosedDeliveryMan = false;
  bool isSending = false;
  bool isFinished;
  Timestamp finishedAt;
  List<ChatMessage> chatMessage = [];
  bool deliveryManAccepted;
  OrderData(
    this.id,
    this.storeName,
    this.client,
    this.clientAddress,
    this.clientAddressId,
    this.clientLat,
    this.clientLng,
    this.clientImage,
    this.clientName,
    this.createdAt,
    this.discount,
    this.paymentType,
    this.shipPrice,
    this.status,
    this.storeDescription,
    this.storeId,
    this.storeAddress,
    this.storeAdressId,
    this.storeLat,
    this.storeLng,
    this.storeImage,
    this.totalPrice,
    this.products,
    this.combos,
    this.vehicleType,
    this.deliveryManData,
    this.paymentOnAppType,
    this.paymentInfo,
    this.deliveryManString,
  );

  OrderData.fromQueryDocument(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    storeName = queryDoc.get("StoreName");
    client = queryDoc.get("client");
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
    totalPrice = queryDoc.get("shipPrice");
    isFinished = queryDoc.get("isFinished");
    deliveryManAccepted = queryDoc.get("deliveryManAccepted");
    if (isFinished) {
      finishedAt = queryDoc.get("finishedAt");
    }
    clientAddress = queryDoc.data()["userLocation"]["clientAddress"];
    clientAddressId = queryDoc.data()["userLocation"]["addressId"];
    clientLat = queryDoc.data()["userLocation"]["lat"];
    clientLng = queryDoc.data()["userLocation"]["lng"];
    storeAddress = queryDoc.data()["storeLocation"]["storeAddress"];
    storeAdressId = queryDoc.data()["storeLocation"]["addressId"];
    storeLat = queryDoc.data()["storeLocation"]["lat"];
    storeLng = queryDoc.data()["storeLocation"]["lng"];
    if (paymentType == "Pagamento no app") {
      paymentOnAppType = queryDoc.data()["dataSale"]["payment"]["type"];
      if (paymentOnAppType == 'DebitCard') {
        paymentInfo = queryDoc.data()["dataSale"]["payment"]['debitCard']
                ["brand"] +
            " - " +
            queryDoc.data()["dataSale"]["payment"]['debitCard']["cardNumber"];
      } else if (paymentOnAppType == 'CreditCard') {
        paymentInfo = queryDoc.data()["dataSale"]["payment"]['creditCard']
                ["brand"] +
            " - " +
            queryDoc.data()["dataSale"]["payment"]['creditCard']["cardNumber"];
      }
    }
    if (queryDoc.get("deliveryMan") != "none") {
      deliveryManData =
          DeliveryManData.fromDynamic(queryDoc.data()["deliveryMan"]);
      isChoosedDeliveryMan = true;
    }
    for (LinkedHashMap p in queryDoc.data()["products"]) {
      products.add(ProductData.fromLinkedHashMap(p));
      totalPrice += p["totalPrice"];
    }
    for (LinkedHashMap combo in queryDoc.data()["combos"]) {
      combos.add(ComboData.fromLinkedHashMap(combo));
      totalPrice += combo["price"] * combo["quantity"];
    }
  }
  OrderData.fromDocumentSnapshot(DocumentSnapshot queryDoc) {
    id = queryDoc.id;
    storeName = queryDoc.get("StoreName");
    client = queryDoc.get("client");
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
    totalPrice = queryDoc.get("shipPrice");
    clientAddress = queryDoc.data()["userLocation"]["clientAddress"];
    clientAddressId = queryDoc.data()["userLocation"]["addressId"];
    clientLat = queryDoc.data()["userLocation"]["lat"];
    clientLng = queryDoc.data()["userLocation"]["lng"];
    storeAddress = queryDoc.data()["storeLocation"]["storeAddress"];
    storeAdressId = queryDoc.data()["storeLocation"]["addressId"];
    storeLat = queryDoc.data()["storeLocation"]["lat"];
    storeLng = queryDoc.data()["storeLocation"]["lng"];
    isSending = queryDoc.get("isSending");
    isFinished = queryDoc.get("isFinished");
    deliveryManAccepted = queryDoc.get("deliveryManAccepted");
    if (isFinished) {
      finishedAt = queryDoc.get("finishedAt");
    }
    if (paymentType == "Pagamento no app") {
      paymentOnAppType = queryDoc.data()["dataSale"]["payment"]["type"];
      if (paymentOnAppType == 'DebitCard') {
        paymentInfo = queryDoc.data()["dataSale"]["payment"]['debitCard']
                ["brand"] +
            " - " +
            queryDoc.data()["dataSale"]["payment"]['debitCard']["cardNumber"];
      } else if (paymentOnAppType == 'CreditCard') {
        paymentInfo = queryDoc.data()["dataSale"]["payment"]['creditCard']
                ["brand"] +
            " - " +
            queryDoc.data()["dataSale"]["payment"]['creditCard']["cardNumber"];
      }
    }
    if (queryDoc.get("deliveryMan") != "none") {
      deliveryManData =
          DeliveryManData.fromDynamic(queryDoc.data()["deliveryMan"]);
      isChoosedDeliveryMan = true;
    }
    for (LinkedHashMap p in queryDoc.data()["products"]) {
      products.add(ProductData.fromLinkedHashMap(p));
      totalPrice += p["totalPrice"];
    }
    for (LinkedHashMap combo in queryDoc.data()["combos"]) {
      combos.add(ComboData.fromLinkedHashMap(combo));
      totalPrice += combo["price"] * combo["quantity"];
    }
  }
}
