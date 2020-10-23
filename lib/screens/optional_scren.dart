import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/tabs/optional_tab.dart';
import 'package:flutter/material.dart';

class OptionalScrenn extends StatefulWidget {
  final ProductData productData;
  OptionalScrenn(this.productData);
  @override
  _OptionalScrennState createState() => _OptionalScrennState();
}

class _OptionalScrennState extends State<OptionalScrenn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opcionais"),
        centerTitle: true,
      ),
      body: new OptionalTab(widget.productData),
    );
  }
}
