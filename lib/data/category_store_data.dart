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
  List<SubSectionData> subSectionsList = [];
  CategoryStoreData({
    @required this.description,
    @required this.image,
    @required this.order,
    @required this.title,
    @required this.x,
    @required this.y,
    @required id,
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
  Map<String, dynamic> toMao() {
    return {
      "description": description,
      "image": image,
      "order": order,
      "title": title,
      "x": x,
      "y": y,
    };
  }
}
