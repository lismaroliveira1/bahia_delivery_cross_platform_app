import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreCategoreData {
  String title;
  String description;
  String image;
  File imageFile;
  StoreCategoreData({
    @required this.title,
    @required this.description,
    @required this.image,
    this.imageFile,
  });
  StoreCategoreData.fromDocument(DocumentSnapshot doc) {
    title = doc.data["title"];
    description = doc.data["description"];
    image = doc.data["image"];
  }

  Map<String, dynamic> toCategoryMap() {
    return {
      "title": title,
      "description": description,
      "image": image,
    };
  }
}
