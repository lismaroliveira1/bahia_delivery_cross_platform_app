import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
