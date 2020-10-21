import 'package:bahia_delivery/tabs/edit_product_tab.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("teste"),
        centerTitle: true,
      ),
      body: EditProductTab(),
    );
  }
}
