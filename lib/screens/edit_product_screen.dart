import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/tabs/edit_product_tab.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  final ProductData productData;
  EditProductScreen(this.productData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("teste"),
        centerTitle: true,
      ),
      body: EditProductTab(productData),
    );
  }
}
