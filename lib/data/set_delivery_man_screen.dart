import 'package:bd_app_full/tabs/set_delivery_man_tab.dart';
import 'package:flutter/material.dart';

class SetDeliveryManScreen extends StatelessWidget {
  final String orderId;
  SetDeliveryManScreen(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SetDeliveryManTab(orderId),
    );
  }
}