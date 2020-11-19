import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreData {
  String id;
  String name;
  String image;
  String description;
  DocumentSnapshot storeSnapshot;
  int openingTimeHour;
  int openingTimeMinute;
  int closingTimeHour;
  int closingTimeMinute;

  StoreData.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    name = documentSnapshot.data["name"];
    image = documentSnapshot.data["image"];
    description = documentSnapshot.data["description"];
    storeSnapshot = documentSnapshot;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": name,
      "image": image,
      "description": description,
    };
  }
}
