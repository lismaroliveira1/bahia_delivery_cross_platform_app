import 'package:cloud_firestore/cloud_firestore.dart';

class CouponData {
  String id;
  String title;
  String description;
  String message;
  int discount;
  DateTime start;
  DateTime end;

  CouponData({
    this.title,
    this.id,
    this.discount,
    this.message,
    this.description,
    this.end,
    this.start,
  });

  CouponData.fromQueryDocumentSnapshot(QueryDocumentSnapshot queryDoc) {
    id = queryDoc.id;
    title = queryDoc.get("title");
    description = queryDoc.get("description");
    message = queryDoc.get("message");
    start =
        (queryDoc.data()["expirationDate"]["startAt"] as Timestamp).toDate();
    end = (queryDoc.data()["expirationDate"]["endAt"] as Timestamp).toDate();
    discount = queryDoc.get("discount");
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "expirationDate": {
        "startAt": start,
        "endAt": end,
      },
      "title": title,
      "description": description,
      "discount": discount,
    };
  }
}
