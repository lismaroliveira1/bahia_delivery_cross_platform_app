import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/data.dart';
import '../models/models.dart';

class CartTile extends StatefulWidget {
  final CartProduct cartProduct;
  final VoidCallback noProduct;
  CartTile({
    @required this.cartProduct,
    @required this.noProduct,
  });

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  int quantity = 0;
  double price;
  @override
  void initState() {
    super.initState();
    price = widget.cartProduct.price;
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
                      widget.cartProduct.productTitle,
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
                        widget.cartProduct.productImage,
                        height: MediaQuery.of(context).size.width / 6.5,
                        width: MediaQuery.of(context).size.width / 6.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  widget.cartProduct.productOptionals.length > 0
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Complementos",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: widget
                                          .cartProduct.productOptionals
                                          .map(
                                            (optionals) => Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    optionals.quantity
                                                            .toString() +
                                                        " x " +
                                                        optionals.title,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    optionals.price
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                          child: Text(
                            "no products",
                            style: TextStyle(
                              color: Colors.amber,
                            ),
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
                            "R\$ ${widget.cartProduct.productPrice.toStringAsFixed(2)}",
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
                                        return TextButton(
                                          child: Text("Remover"),
                                          onPressed: () {
                                            UserModel.of(context)
                                                .removeCartItem(
                                              cartProduct: widget.cartProduct,
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
                                            .doc(widget.cartProduct.cId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container(
                                              height: 0,
                                              width: 0,
                                            );
                                          } else {
                                            price = snapshot.data["totalPrice"];
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
                          icon: Icon(
                            Icons.remove,
                            color: Colors.black54,
                          ),
                          onPressed: widget.cartProduct.quantify > 1
                              ? () {
                                  UserModel.of(context)
                                      .decProduct(widget.cartProduct);
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
                                    .doc(widget.cartProduct.cId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      height: 0,
                                      width: 0,
                                    );
                                  } else {
                                    quantity = snapshot.data["quantity"];
                                    return Text(
                                      quantity.toString(),
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    );
                                  }
                                });
                          }
                        }),
                        IconButton(
                          onPressed: () {
                            UserModel.of(context)
                                .incProduct(widget.cartProduct);
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

  void _onSuccess() {
    if (!(UserModel.of(context).cartProducts.length == 0)) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _onFail() {}
}
