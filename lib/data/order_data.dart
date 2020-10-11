import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderData {
  String storeId;
  String date;
  String price;
  String shipPrice;
  String storeImage;
  String storeDescription;
  String deliveryManName;

  OrderData({
    @required this.storeId,
    @required this.storeImage,
    @required this.storeImage,
    @required this.storeDescription,
    @required this.date,
    @required this.deliveryManName,
    @required this.price,
    @required this.shipPrice,
  });

  OrderData.fromDocument(DocumentSnapshot documentSnapshot) {}
}
