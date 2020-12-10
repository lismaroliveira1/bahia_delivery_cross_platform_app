import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CategoryData {
  String image;
  String title;
  String id;

  CategoryData({
    @required this.image,
    @required this.title,
    @required this.id,
  });
  CategoryData.fromQueryDocument(QueryDocumentSnapshot queryDocumentSnapshot) {
    image = queryDocumentSnapshot.get("image");
    title = queryDocumentSnapshot.get("title");
    id = queryDocumentSnapshot.id;
  }
}
