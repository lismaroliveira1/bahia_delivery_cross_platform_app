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
  bool ishourSeted = false;

  StoreData.fromDocument(DocumentSnapshot documentSnapshot) {
    bool isClosingTimeSeted = false;
    bool isOpeningTimeConfigurated = false;
    id = documentSnapshot.documentID;
    name = documentSnapshot.data["name"];
    image = documentSnapshot.data["image"];
    description = documentSnapshot.data["description"];
    storeSnapshot = documentSnapshot;
    if (documentSnapshot.data["closingTime"] != null) {
      Map map = documentSnapshot.data["closingTime"];
      closingTimeHour = map["hour"];
      closingTimeMinute = map["minute"];
      isClosingTimeSeted = true;
    }
    if (documentSnapshot.data["openingTime"] != null) {
      Map map = documentSnapshot.data["openingTime"];
      openingTimeHour = map["hour"];
      openingTimeMinute = map["minute"];
      isOpeningTimeConfigurated = true;
    }
    if (isClosingTimeSeted && isOpeningTimeConfigurated) ishourSeted = true;
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
