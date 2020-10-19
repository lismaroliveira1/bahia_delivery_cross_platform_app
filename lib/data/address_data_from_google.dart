import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

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
  AddressDataFromGoogle.fromPrediction(AutocompletePrediction prediction) {
    description = prediction.description;
    id = prediction.id;
    placeId = prediction.placeId;
    reference = prediction.reference;
  }
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "id": id,
      "placeId": placeId,
      "reference": reference
    };
  }
}
