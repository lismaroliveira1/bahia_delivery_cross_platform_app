import 'package:cloud_firestore/cloud_firestore.dart';

class StoreData {
  String category;
  String id;
  String title;
  String description;

  StoreData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    category = snapshot.data["category"];
    description = snapshot.data["descxrition"];
  }
}
