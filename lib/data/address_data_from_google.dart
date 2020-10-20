import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class AddressDataFromGoogle {
  String description;
  String placeId;
  String reference;
  String id;
  bool isDefined = false;
  AddressDataFromGoogle({
    this.isDefined,
    this.id,
    @required this.description,
    @required this.placeId,
    @required this.reference,
  });
  AddressDataFromGoogle.fromPrediction(AutocompletePrediction prediction) {
    description = prediction.description;
    placeId = prediction.placeId;
    reference = prediction.reference;
  }
  AddressDataFromGoogle.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    description = documentSnapshot.data["descripition"];
    placeId = documentSnapshot.data["placeId"];
    reference = documentSnapshot.data["reference"];
    isDefined = documentSnapshot.data["isDefined"];
  }
  Map<String, dynamic> toMap() {
    return {
      "descripition": description,
      "placeId": placeId,
      "reference": reference
    };
  }
}
