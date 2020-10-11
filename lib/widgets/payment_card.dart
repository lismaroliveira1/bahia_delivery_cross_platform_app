import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/payment_screen.dart';
import 'package:bahia_delivery/tiles/creditcard_tile.dart';
import 'package:bahia_delivery/tiles/payement_on_delivery_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymentCard extends StatefulWidget {
  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.isLoading && UserModel.of(context).isLoggedIn()) {
        return Container(
          height: 0.0,
          width: 0.0,
        );
      } else {
        return FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PaymentScreen()));
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Container(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                        if (model.paymentSet) {
                          if (model.payOnApp) {
                            return CreditDebitCardTileNB(
                              model.currentCreditDebitCardData,
                            );
                          } else {
                            return PaymentOnDeliveryTile(
                              model.currentPaymentOndeliveryData,
                            );
                          }
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(left: 12, right: 16),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.payment,
                                  color: Colors.grey[700],
                                ),
                                SizedBox(
                                  width: 32,
                                ),
                                Text(
                                  "Pagamento",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                      Spacer(),
                      Icon(
                        Icons.edit,
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
