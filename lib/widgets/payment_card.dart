import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymentCard extends StatelessWidget {
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
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Center(
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
                        "Visa .... 2015",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                            fontSize: 16),
                      ),
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
