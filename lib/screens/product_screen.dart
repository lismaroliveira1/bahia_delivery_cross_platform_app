import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/tabs/product_store_tab.dart';
import 'package:flutter/material.dart';

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
