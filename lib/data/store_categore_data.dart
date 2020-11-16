import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreCategoreData {
  String id;
  String title;
  String description;
  String image;
  File imageFile;
  int order;
  int x;
  int y;
  StoreCategoreData({
    @required this.title,
    @required this.description,
    @required this.image,
    this.imageFile,
    this.id,
    this.order,
    this.x,
    this.y,
  });
  StoreCategoreData.fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    title = doc.data["title"];
    description = doc.data["description"];
    image = doc.data["image"];
    order = doc.data["order"];
    x = doc.data["x"];
    y = doc.data["y"];
  }

  Map<String, dynamic> toCategoryMap() {
    return {
      "title": title,
      "description": description,
      "image": image,
    };
  }
}
