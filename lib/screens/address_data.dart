import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressData {
  String address;
  String addressId;
  double lat;
  double lng;
  String id;

  AddressData({
    @required this.address,
    @required this.addressId,
    @required this.lat,
    @required this.lng,
  });

  AddressData.fromQueryDocumentSnapshot(QueryDocumentSnapshot query) {
    id = query.id;
    address = query.get("address");
    addressId = query.get("addressId");
    lat = query.get("lat");
    lng = query.get("lng");
  }

  Map<String, dynamic> toMap() {
    return {
      "address": address,
      "addressId": addressId,
      "lat": lat,
      "lng": lng,
    };
  }
}
