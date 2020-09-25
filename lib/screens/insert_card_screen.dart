import 'package:bahia_delivery/widgets/credit_card_section.dart';
import 'package:flutter/material.dart';

class InsertPaymentScreen extends StatefulWidget {
  @override
  _InsertPaymentScreenState createState() => _InsertPaymentScreenState();
}

class _InsertPaymentScreenState extends State<InsertPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inserir Cartão"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: CreditCardSession(),
            )
          ],
        ),
      ),
    );
  }
}
