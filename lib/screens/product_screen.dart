import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

class ProductStoreScreen extends StatelessWidget {
  final ProductData productData;
  final StoreData storeData;
  ProductStoreScreen(this.productData, this.storeData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductStoreTab(productData, storeData),
    );
  }
}
