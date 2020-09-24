import 'package:bahia_delivery/widgets/credit_card_section.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagamentos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: CreditCardSession(),
          ),
        ],
      ),
    );
  }
}
