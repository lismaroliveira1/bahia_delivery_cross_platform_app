import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
