import 'package:bahia_delivery/tabs/create_edite_product_tab.dart';
import 'package:flutter/material.dart';

class CreateEditProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
        centerTitle: true,
      ),
      body: CreateEditProductTab(),
    );
  }
}
