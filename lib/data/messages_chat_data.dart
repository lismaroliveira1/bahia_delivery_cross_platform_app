import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChatData {
  String id;
  String text;
  String image;
  bool read;
  String from;
  String type;
  String userId;
  String storeId;
  Timestamp createdAt;

  MessageChatData.fromQueryDocumentSnaphot(queryDoc) {
    id = queryDoc.id;
    text = queryDoc.get("text");
    createdAt = queryDoc.get("createdAt");
    read = queryDoc.get("read");
    from = queryDoc.get("from");
  }
}
