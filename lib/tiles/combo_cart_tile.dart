import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/data.dart';
import '../models/models.dart';

class ComboCartTile extends StatefulWidget {
  final ComboData comboData;
  ComboCartTile(this.comboData);
  @override
  _ComboCartTileState createState() => _ComboCartTileState();
}

class _ComboCartTileState extends State<ComboCartTile> {
  ComboData comboData;
  double price = 0;
  int quantity = 0;
  @override
  void initState() {
    super.initState();
    comboData = widget.comboData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  6.0,
                  0,
                  0,
                  0,
                ),
                child: Row(
                  children: [
                    Text(
                      widget.comboData.title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.comboData.image,
                        height: MediaQuery.of(context).size.width / 6.5,
                        width: MediaQuery.of(context).size.width / 6.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.comboData.description,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 6.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "R\$ ${widget.comboData.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: Container(
                              height: 20,
                              child: Row(
                                children: <Widget>[
                                  StreamBuilder<Object>(
                                      stream: null,
                                      builder: (context, snapshot) {
                                        return FlatButton(
                                          padding: EdgeInsets.zero,
                                          child: Text("Remover"),
                                          textColor: Colors.grey[500],
                                          onPressed: () {
                                            UserModel.of(context)
                                                .removeComboCartItem(
                                              cartComboData: comboData,
                                              onSuccess: _onSuccess,
                                              onFail: _onFail,
                                            );
                                          },
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ScopedModelDescendant<UserModel>(
                                    builder: (context, child, model) {
                                  if (model.isLoading) {
                                    return Container(
                                      height: 0,
                                    );
                                  } else {
                                    return StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(UserModel.of(context)
                                                .firebaseUser
                                                .uid)
                                            .collection("cart")
                                            .doc(widget.comboData.id)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container(
                                              height: 0,
                                              width: 0,
                                            );
                                          } else {
                                            price = snapshot.data["price"];
                                            return Container(
                                              child: Text(
                                                "R\$ ${price.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                  }
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.remove,
                            color: Colors.black54,
                          ),
                          onPressed: comboData.quantity > 0
                              ? () {
                                  UserModel.of(context).decComboCartItem(
                                    cartComboData: comboData,
                                  );
                                }
                              : null,
                        ),
                        ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                          if (model.isLoading) {
                            return Container(
                              height: 0,
                            );
                          } else {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(UserModel.of(context).firebaseUser.uid)
                                    .collection("cart")
                                    .doc(widget.comboData.id)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      height: 0,
                                      width: 0,
                                    );
                                  } else {
                                    comboData.quantity =
                                        snapshot.data["quantity"];
                                    return Text(
                                      comboData.quantity.toString(),
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    );
                                  }
                                });
                          }
                        }),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            UserModel.of(context).incComboCartItem(
                              cartComboData: comboData,
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
        )
      ],
    );
  }

  void _onSuccess() {}
  void _onFail() {}
}
