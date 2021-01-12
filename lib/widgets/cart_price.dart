import 'dart:async';

import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/payment_screen.dart';
import 'package:bd_app_full/services/cielo_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatefulWidget {
  final StoreData storeData;
  CartPrice(this.storeData);
  @override
  _CartPriceState createState() => _CartPriceState();
}

class _CartPriceState extends State<CartPrice> {
  final CieloPayment cieloPayment = CieloPayment();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<void> waitForAndFail([int seconds = 2]) async {
    await Future.delayed(Duration(seconds: seconds));
    throw Exception();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, userModel) {
      return Padding(
        padding: EdgeInsets.zero,
        child: Card(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                if (model.isLoading) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  double ship = model.getShipPrice();
                  double discount = model.getDiscountPrice();
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(model.firebaseUser.uid)
                        .collection("cart")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      } else {
                        double totalPrice = 0;
                        double totalProductsPrice = 0;
                        double totalCombosPrice = 0;
                        List<DocumentSnapshot> comboItens = snapshot.data.docs
                            .where(
                              (element) =>
                                  element.get("type") == "combo" &&
                                  element.get("storeId") == widget.storeData.id,
                            )
                            .toList();
                        for (DocumentSnapshot doc in comboItens) {
                          totalCombosPrice +=
                              doc.get("price") * doc.get("quantity");
                        }
                        List<DocumentSnapshot> items = snapshot.data.docs
                            .where(
                              (element) =>
                                  element.get("type") == "product" &&
                                  element.get("storeId") == widget.storeData.id,
                            )
                            .toList();
                        for (DocumentSnapshot doc in items) {
                          totalProductsPrice += doc.get("totalPrice");
                        }

                        totalPrice = totalProductsPrice +
                            ship -
                            discount +
                            totalCombosPrice;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "Resumo do pedido",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Subtotal",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "R\$ ${(totalProductsPrice + totalCombosPrice).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                )
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Desconto",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "- R\$ ${discount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Frete",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "R\$ ${ship.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  "R\$ ${totalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RoundedLoadingButton(
                                      color: Colors.red,
                                      child: Text(
                                        'Finalizar Pedido',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      controller: _btnController,
                                      onPressed: () async {
                                        if (!userModel.paymentSet) {
                                          _btnController.reset();
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: PaymentScreen(),
                                              inheritTheme: true,
                                              duration: Duration(
                                                milliseconds: 350,
                                              ),
                                              ctx: context,
                                            ),
                                          );
                                        } else {
                                          if (userModel.payOnApp) {
                                            if (userModel
                                                .currentCreditDebitCardData
                                                .isDebit) {
                                              print("debit");
                                              await userModel
                                                  .finishOrderWithPayOnAppByDebitCard(
                                                onSuccess: _onSuccessPayOnApp,
                                                onFail: _onFailOnApp,
                                                shipePrice: ship,
                                                storeData: widget.storeData,
                                                discount: discount,
                                                onCartExpired: _onCardExpired,
                                                onTimeOut: _onTimeOut,
                                                onFailDebitCard:
                                                    _onFailDebitCard,
                                              );
                                            } else {
                                              await userModel
                                                  .finishOrderWithPayOnAppByCretditCard(
                                                onSuccess: _onSuccessPayOnApp,
                                                onFail: _onFailOnApp,
                                                shipePrice: ship,
                                                storeData: widget.storeData,
                                                discount: discount,
                                                onCartExpired: _onCardExpired,
                                                onTimeOut: _onTimeOut,
                                              );
                                            }
                                          } else {
                                            await userModel
                                                .finishOrderWithPayOnDelivery(
                                              discount: discount,
                                              onSuccess: _onSuccessPay,
                                              shipePrice: ship,
                                              storeData: widget.storeData,
                                              onFail: _onFailPay,
                                            );
                                          }
                                        }
                                      },
                                      width: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ),
      );
    });
  }

  void _onSuccessPay() {
    Navigator.of(context).pop();
  }

  void _onFailPay() {}

  void _onSuccessPayOnApp() {
    Navigator.of(context).pop();
  }

  void _onFailOnApp() {}

  _onCardExpired() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Cartão inválido",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onTimeOut() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tempo expirado tente novamente",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFailDebitCard() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tente usar outro cartão de débito",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void noAddressConfigured() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tente usar outro cartão de débito",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
