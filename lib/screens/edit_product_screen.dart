import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/tabs/edit_product_tab.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  final ProductData productData;
  EditProductScreen(this.productData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditProductTab(productData),
    );
  }
}
