import 'package:flutter/cupertino.dart';

import '../data/data.dart';

class CartData {
  List<CartProduct> carts = [];
  StoreData storeData;
  CartData({
    @required this.carts,
    @required this.storeData,
  });
}
