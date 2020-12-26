import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/tabs/chat_user_order_tab.dart';
import 'package:flutter/material.dart';

class ChatUserOrderScreen extends StatelessWidget {
  final OrderData orderData;
  ChatUserOrderScreen(this.orderData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatUserOrderTab(orderData),
    );
  }
}
