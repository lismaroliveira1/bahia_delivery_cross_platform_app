import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubSectionData {
  String id;
  int order;
  String title;
  String sectionId;

  SubSectionData({
    @required this.order,
    @required this.title,
    @required this.sectionId,
  });

  SubSectionData.fromQuerDocument(
      QueryDocumentSnapshot queryDoc, String sectionId) {
    id = queryDoc.id;
    order = queryDoc.get("order");
    title = queryDoc.get("title");
    sectionId = sectionId;
  }
  Map<String, dynamic> toMap() {
    return {
      "order": order,
      "title": title,
      "sectionId": sectionId,
    };
  }
}
