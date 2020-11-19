import 'package:bahia_delivery/models/cart_model.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/services/cielo_payment.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final CieloPayment cieloPayment = CieloPayment();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
      return Padding(
        padding: EdgeInsets.zero,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                double price = model.getProductsPrice();
                double ship = model.getShipPrice();
                double discount = model.getDiscountPrice();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Resumo do pedido",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Subtotal"),
                        Text("R\$ ${price.toStringAsFixed(2)}"),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Desconto"),
                        Text("- R\$ ${discount.toStringAsFixed(2)}"),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Frete"),
                        Text("R\$ ${ship.toStringAsFixed(2)}"),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "R\$ ${(price + ship - discount).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        height: 60,
                        child: RaisedButton(
                          onPressed: () async {
                            if (userModel.payOnApp) {
                              print("payOnApp");
                            } else {
                              await model.finishOrderWithPayOnDelivery();
                              UserModel.of(context).veryIfExistsProducts();
                            }
                          },
                          child: Text("Finalizar Pedido"),
                          textColor: Colors.white,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
