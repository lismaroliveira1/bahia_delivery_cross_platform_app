import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/services/cielo_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatefulWidget {
  final StoreData storeData;
  CartPrice(this.storeData);
  @override
  _CartPriceState createState() => _CartPriceState();
}

class _CartPriceState extends State<CartPrice> {
  final CieloPayment cieloPayment = CieloPayment();

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
                            .where((element) => element.get("type") == "combo")
                            .toList();
                        for (DocumentSnapshot doc in comboItens) {
                          totalCombosPrice +=
                              doc.get("price") * doc.get("quantity");
                        }
                        List<DocumentSnapshot> items = snapshot.data.docs
                            .where(
                                (element) => element.get("type") == "product")
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                height: 60,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (userModel.payOnApp) {
                                      print("payOnApp");
                                      userModel.finishOrder(
                                        discount: discount,
                                        onSuccess: _onSuccessPayOnApp,
                                        onFail: _onFailOnApp,
                                        shipePrice: ship,
                                        storeData: widget.storeData,
                                        creditDebitCardData: userModel
                                            .currentCreditDebitCardData,
                                      );
                                    } else {
                                      userModel.finishOrderWithPayOnDelivery(
                                        discount: discount,
                                        onSuccess: _onSuccessPay,
                                        shipePrice: ship,
                                        storeData: widget.storeData,
                                        onFail: _onFailPay,
                                      );
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
}
