import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
              Center(
                child: Text(
                  widget.cartProduct.productTitle,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0),
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
                        height: MediaQuery.of(context).size.width / 4.2,
                        width: MediaQuery.of(context).size.width / 4.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  widget.cartProduct.productOptionals.length > 0
                      ? Container(
                          height: MediaQuery.of(context).size.width / 4.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: widget.cartProduct.productOptionals
                                      .map(
                                        (optionals) => Row(
                                          children: [
                                            Text(
                                              optionals.quantity.toString() +
                                                  " x " +
                                                  optionals.title,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              " R\$ ${optionals.price.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                                child: Container(
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.black54,
                                            ),
                                            onPressed: widget
                                                        .cartProduct.quantify >
                                                    1
                                                ? () {
                                                    CartModel.of(context)
                                                        .decProduct(
                                                            widget.cartProduct);
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
                                              return StreamBuilder<
                                                      DocumentSnapshot>(
                                                  stream: Firestore.instance
                                                      .collection("users")
                                                      .document(
                                                          UserModel.of(context)
                                                              .firebaseUser
                                                              .uid)
                                                      .collection("cart")
                                                      .document(widget
                                                          .cartProduct.cId)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Container(
                                                        height: 0,
                                                        width: 0,
                                                      );
                                                    } else {
                                                      quantity = snapshot
                                                          .data["quantity"];
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
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              CartModel.of(context).incProduct(
                                                  widget.cartProduct);
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
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
                      height: MediaQuery.of(context).size.width / 4.2,
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
                                        return FlatButton(
                                          padding: EdgeInsets.zero,
                                          child: Text("Remover"),
                                          textColor: Colors.grey[500],
                                          onPressed: () {
                                            UserModel.of(context)
                                                .removeCartItem(
                                                    widget.cartProduct);
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
                                        stream: Firestore.instance
                                            .collection("users")
                                            .document(UserModel.of(context)
                                                .firebaseUser
                                                .uid)
                                            .collection("cart")
                                            .document(widget.cartProduct.cId)
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
            ],
          ),
        ),
        Divider(
          color: Colors.black,
        )
      ],
    );
  }
}
