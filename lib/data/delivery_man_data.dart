import 'dart:io';

import 'package:flutter/cupertino.dart';

class DeliveryManData {
  File imageFile;
  String name;
  DateTime birthDay;
  String cpf;
  String location;
  double lat;
  double lng;
  String locationId;
  String image;
  String userId;
  
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
    };
  }
}
