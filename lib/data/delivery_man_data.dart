import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DeliveryManData {
  File imageFile;
  String id;
  String name;
  DateTime birthDay;
  String cpf;
  String location;
  double lat;
  double lng;
  String locationId;
  String image;
  String userId;
  String vehycleType;
  String vehycleColor;
  String transitBoard;
  String transitId;
  String driverIdImage;
  File driverImageFile;
  DeliveryManData.fromDocument(DocumentSnapshot docSnap) {
    id = docSnap.id;
    name = docSnap.get("name");
    birthDay = (docSnap.get("birthDay") as Timestamp).toDate();
    cpf = docSnap.get("cpf");
    location = docSnap.get("location");
    lat = docSnap.get("lat");
    lng = docSnap.get("lng");
    locationId = docSnap.get("locationId");
    userId = docSnap.get("userId");
    image = docSnap.get("image");
  }
  DeliveryManData.fromDynamic(dynamic docSnap) {
    name = docSnap["name"];
    image = docSnap["image"];
  }
  DeliveryManData.fromQuerySnapshot(QueryDocumentSnapshot docSnap) {
    id = docSnap.id;
    name = docSnap.get("name");
    birthDay = (docSnap.get("birthDay") as Timestamp).toDate();
    cpf = docSnap.get("cpf");
    location = docSnap.get("location");
    lat = docSnap.get("lat");
    lng = docSnap.get("lng");
    locationId = docSnap.get("locationId");
    userId = docSnap.get("userId");
    image = docSnap.get("image");
    vehycleType = docSnap.get("vehicleType");
    if (vehycleType == 'Motorizado') {
      vehycleColor = docSnap.get("vehicleColor");
      transitId = docSnap.get("transitId");
      driverIdImage = docSnap.get("driverIdImage");
    }
  }

  DeliveryManData({
    @required this.birthDay,
    @required this.cpf,
    @required this.imageFile,
    @required this.lat,
    @required this.lng,
    @required this.location,
    @required this.locationId,
    @required this.name,
    @required this.image,
    this.userId,
    @required this.vehycleColor,
    @required this.vehycleType,
    @required this.transitId,
    @required this.transitBoard,
    this.driverIdImage,
    @required this.driverImageFile,
  });

  Map<String, dynamic> toRequestMap() {
    return {
      "name": name,
      "birthDay": birthDay,
      "cpf": cpf,
      "location": location,
      "locationId": locationId,
      "lat": lat,
      "lng": lng,
      "image": image,
      "userId": userId,
      "vehicleColor": vehycleColor,
      "vehicleType": vehycleType,
      "transitId": transitId,
      "driverIdImage": driverIdImage,
    };
  }
}
