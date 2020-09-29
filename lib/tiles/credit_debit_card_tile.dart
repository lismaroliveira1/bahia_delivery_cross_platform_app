import 'package:bahia_delivery/data/credit_debit_card_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';

class CreditDebitCardTile extends StatelessWidget {
  final CreditDebitCardData creditDebitCardData;
  CreditDebitCardTile(this.creditDebitCardData);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          UserModel.of(context).setCurrentCrediCard(creditDebitCardData);
          Navigator.of(context).pop();
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
            Text("*** *** *** " +
                creditDebitCardData.cardNumber.substring(15, 19))
          ],
        ),
      ),
    );
  }
}
