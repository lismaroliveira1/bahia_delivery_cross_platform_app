import 'package:bahia_delivery/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  DocumentSnapshot doc;
  String orderId;
  String storeId;
  String client;
  Timestamp createdAt;
  double totalPrice;
  double shipPrice;

  ProductData productData;
  OrderData(this.orderId, this.storeId, this.client, this.createdAt,
      this.totalPrice, this.shipPrice, this.doc);

  OrderData.fromDocument(DocumentSnapshot documentSnapshot) {
    orderId = documentSnapshot.documentID;
    storeId = documentSnapshot.data["storeId"];
    client = documentSnapshot.data["clients"];
    createdAt = documentSnapshot.data["createdAt"];
    //TODO Passar a imagem da loja storeImage = documentSnapshot.data["storeImage"];
    totalPrice = documentSnapshot.data["totalPrice"];
    shipPrice = documentSnapshot.data["shipPrice"];
    doc = documentSnapshot;
  }

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "storeiId": storeId,
      "client": client,
      "createdAt": createdAt,
      "totalPrice": shipPrice,
    };
  }
}
