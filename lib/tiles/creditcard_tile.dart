import 'package:bahia_delivery/data/credit_debit_card_data.dart';
import 'package:bahia_delivery/screens/payment_screen.dart';
import 'package:flutter/material.dart';

class CreditDebitCardTileNB extends StatelessWidget {
  final CreditDebitCardData creditDebitCardData;
  CreditDebitCardTileNB(this.creditDebitCardData);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentScreen(),
        ));
      },
      child: Row(
        children: <Widget>[
          Container(
            height: 20,
            child: Image.asset(
              creditDebitCardData.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "*** *** *** " + creditDebitCardData.cardNumber.substring(15, 19),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }
}
