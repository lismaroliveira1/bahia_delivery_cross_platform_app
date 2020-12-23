import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/tabs/real_time_delivery_user_tab.dart';
import 'package:flutter/material.dart';

class RealTimeDeliveryUserScreen extends StatelessWidget {
  final OrderData orderData;
  RealTimeDeliveryUserScreen(this.orderData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RealTimeDeliveryUserTab(orderData),
    );
  }
}
