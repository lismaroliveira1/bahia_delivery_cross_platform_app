import 'package:bd_app_full/tabs/payment_user_tab.dart';
import 'package:flutter/material.dart';

class PaymentUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: PaymentUserTab(),
      ),
    );
  }
}