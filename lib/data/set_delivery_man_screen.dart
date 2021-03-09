import 'package:flutter/material.dart';

import '../tabs/tabs.dart';

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
