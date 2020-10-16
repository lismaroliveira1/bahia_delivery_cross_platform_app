import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {
  String message;
  String id;
  String image;
  DateTime createdAt;

  MessageData.fromDocument(DocumentSnapshot documentSnapshot) {
    message = documentSnapshot.data["text"];
    id = documentSnapshot.data["userId"];
    image = documentSnapshot.data["image"];
    createdAt = documentSnapshot.data["createdAt"];
  }
}
