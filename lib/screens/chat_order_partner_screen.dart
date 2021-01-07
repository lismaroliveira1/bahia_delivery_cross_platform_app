import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/tabs/chat_order_partner_tab.dart';
import 'package:flutter/material.dart';

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
