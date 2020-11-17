import 'package:bahia_delivery/tabs/order_store_tab.dart';
import 'package:flutter/material.dart';

class OrderStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pedidos"),
      ),
      body: OrderStoreTab(),
    );
  }
}
