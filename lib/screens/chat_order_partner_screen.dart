import 'package:flutter/material.dart';

import '../data/order_data.dart';
import '../tabs/tabs.dart';

class ChatOrderPartnerScreen extends StatelessWidget {
  final OrderData orderData;
  ChatOrderPartnerScreen(this.orderData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatOrderPartnerTab(orderData),
    );
  }
}
