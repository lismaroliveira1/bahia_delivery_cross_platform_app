import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/components.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../tiles/tiles.dart';

class PaymentUserTab extends StatefulWidget {
  @override
  _PaymentUserTabState createState() => _PaymentUserTabState();
}

class _PaymentUserTabState extends State<PaymentUserTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 100,
              )
            ];
          },
          body: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white60,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, bottom: 4),
                              child: Row(
                                children: [
                                  Text(
                                    "Cartões",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  ScopedModelDescendant<UserModel>(
                                      builder: (context, child, model) {
                                    if (model.creditDebitCardList.length != 0) {
                                      return IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            pageTransition(
                                              context: context,
                                              screen: new PaymentScreen(),
                                            );
                                          });
                                    } else {
                                      return Container(
                                        height: 0,
                                        width: 0,
                                      );
                                    }
                                  }),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ScopedModelDescendant<UserModel>(
                                  builder: (context, child, model) {
                                if (model.creditDebitCardList.length == 0) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 35,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Adcionar novo cartão",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          InsertPaymentScreen(),
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        ScopedModelDescendant<UserModel>(
                                          builder: (context, child, model) {
                                            if (model.isLoading) {
                                              return Container(
                                                height: 0,
                                                width: 0,
                                              );
                                            } else {
                                              return Column(
                                                children: model.paymentFormsList
                                                    .map((paymentForm) {
                                                  return FlatButton(
                                                    onPressed: () {},
                                                    child: CreditDebitCardTile(
                                                      paymentForm
                                                          .creditDebitCardData,
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                    child: Column(
                                        children: model.creditDebitCardList.map(
                                      (card) {
                                        return CreditDebitCardTile(card);
                                      },
                                    ).toList()),
                                  );
                                }
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Pagementos na entrega",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white60,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  child: FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      final PaymentOnDeliveryData
                                          paymentOnDeliveryData =
                                          PaymentOnDeliveryData(
                                        image: "images/money.png",
                                        description: "Dinheiro",
                                      );
                                      UserModel.of(context)
                                          .setPaymentOnDeliveryMethod(
                                              paymentOnDeliveryData);
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 25,
                                          child: Image.asset(
                                            "images/money.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text("Dinheiro")
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  child: FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      final PaymentOnDeliveryData
                                          paymentOnDeliveryData =
                                          PaymentOnDeliveryData(
                                              image:
                                                  "images/credit_debit_card.png",
                                              description: "Cartão de Credito");
                                      UserModel.of(context)
                                          .setPaymentOnDeliveryMethod(
                                              paymentOnDeliveryData);
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 25,
                                          child: Image.asset(
                                            "images/credit_debit_card.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text("Cartão de Credito")
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  child: FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      final PaymentOnDeliveryData
                                          paymentOnDeliveryData =
                                          PaymentOnDeliveryData(
                                              image:
                                                  "images/credit_debit_card.png",
                                              description:
                                                  "Cartão de débito (Visa ou Master)");
                                      UserModel.of(context)
                                          .setPaymentOnDeliveryMethod(
                                              paymentOnDeliveryData);
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 25,
                                          child: Image.asset(
                                            "images/credit_debit_card.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                            "Cartão de débito (Visa ou Master)")
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
