import 'package:bahia_delivery/tabs/sales_off_tab.dart';
import 'package:flutter/material.dart';

class SalesOffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Promoções"),
      ),
      body: SalesOffTab(),
    );
  }
}
