import 'package:bahia_delivery/data/product_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  String storeId;
  String client;
  Timestamp createdAt;
  double totalPrice;
  double shipPrice;

  ProductData productData;
  OrderData(
    this.storeId,
    this.client,
    this.createdAt,
    this.totalPrice,
    this.shipPrice,
  );

  OrderData.fromDocument(DocumentSnapshot documentSnapshot) {
    storeId = documentSnapshot.data["storeId"];
    client = documentSnapshot.data["clients"];
    createdAt = documentSnapshot.data["createdAt"];
    //TODO Passar a imagem da loja storeImage = documentSnapshot.data["storeImage"];
    totalPrice = documentSnapshot.data["totalPrice"];
    shipPrice = documentSnapshot.data["shipPrice"];
  }

  Map<String, dynamic> toMap() {
    return {
      "storeiId": storeId,
      "client": client,
      "createdAt": createdAt,
      "totalPrice": shipPrice,
    };
  }
}
