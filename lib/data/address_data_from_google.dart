import 'package:flutter/material.dart';

class AddressDataFromGoogle {
  String description;
  String id;
  String placeId;
  String reference;
  AddressDataFromGoogle({
    @required this.description,
    @required this.id,
    @required this.placeId,
    @required this.reference,
  });
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "id": id,
      "placeId": placeId,
      "reference": reference
    };
  }
}
