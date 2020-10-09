import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryData {
  String title;
  String image;

  CategoryData.fromDocument(DocumentSnapshot documentSnapahot) {
    title = documentSnapahot.data["title"];
    image = documentSnapahot.data["image"];
  }
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "image": image,
    };
  }
}
