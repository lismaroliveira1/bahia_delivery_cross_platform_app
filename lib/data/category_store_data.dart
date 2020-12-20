import 'dart:io';

import 'package:bd_app_full/data/subsection_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryStoreData {
  String id;
  String description;
  String image;
  int order;
  String title;
  int x;
  int y;
  File imageFile;
  List<SubSectionData> subSectionsList = [];
  CategoryStoreData({
    @required this.description,
    this.image,
    @required this.order,
    @required this.title,
    @required this.x,
    @required this.y,
    id,
    @required this.imageFile,
  });
  CategoryStoreData.fromQueryDocument(QueryDocumentSnapshot query) {
    id = query.id;
    description = query.get("description");
    image = query.get("image");
    order = query.get("order");
    title = query.get("title");
    x = query.get("x");
    y = query.get("y");
  }
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "image": image,
      "order": order,
      "title": title,
      "x": x,
      "y": y,
      "subsections": subSectionsList.map((subsectionData) {
        return subsectionData.toMap();
      }).toList()
    };
  }
}
