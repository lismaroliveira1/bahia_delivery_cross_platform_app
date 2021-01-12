import 'package:bd_app_full/data/cart_product.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:flutter/cupertino.dart';

class CartData {
  List<CartProduct> carts = [];
  StoreData storeData;
  CartData({
    @required this.carts,
    @required this.storeData,
  });
}
