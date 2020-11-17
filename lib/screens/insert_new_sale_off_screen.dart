import 'package:bahia_delivery/tabs/insert_new_sale_off_tab.dart';
import 'package:flutter/material.dart';

class InsertNewSaleOffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova promoção"),
        centerTitle: true,
      ),
      body: InsertNewSaleOffTab(),
    );
  }
}
