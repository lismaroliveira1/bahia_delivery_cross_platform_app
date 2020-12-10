import 'dart:collection';

class ComplementData {
  String description;
  String id;
  String image;
  double price;
  String productId;
  int quantity;
  String title;

  ComplementData.fromLinkedHashMap(LinkedHashMap queryDoc) {
    description = queryDoc["description"];
    id = queryDoc["id"];
    image = queryDoc["image"];
    price = queryDoc["price"];
    quantity = queryDoc["quantity"];
    title = queryDoc["title"];
  }
}
