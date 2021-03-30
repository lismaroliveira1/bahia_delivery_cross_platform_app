import 'package:bd_app_full/components/components.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../tiles/tiles.dart';

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
        return TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Duration(seconds: 10);
            pageTransition(
              context: context,
              screen: new PaymentScreen(),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: Container(
              height: 60,
              color: Colors.white,
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
                                    fontSize: 16,
                                  ),
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
