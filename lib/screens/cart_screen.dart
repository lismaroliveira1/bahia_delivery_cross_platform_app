import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/tabs/cart_tab.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final StoreData storeData;
  CartScreen(this.storeData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CartTab(storeData),
    );
  }
}
