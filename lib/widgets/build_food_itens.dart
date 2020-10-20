import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:bahia_delivery/screens/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FoodItem extends StatefulWidget {
  final String imgPath;
  final String foodName;
  final double price;
  final String description;
  final DocumentSnapshot snapshot;
  final String storeId;

  FoodItem(
      {@required this.storeId,
      @required this.imgPath,
      @required this.foodName,
      @required this.price,
      @required this.description,
      @required this.snapshot});

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  CartProduct cartProduct = CartProduct();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(
      builder: (context, child, model) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: [
                        Hero(
                          tag: widget.imgPath,
                          child: Container(
                            height: 60,
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.imgPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.foodName,
                                style: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'R' + '\$' + widget.price.toString(),
                                style: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                widget.description,
                                style: TextStyle(
                                  fontFamily: 'MontSerrat',
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.black,
                    onPressed: () {
                      CartProduct cartProduct = CartProduct();
                      cartProduct.quantify = 1;
                      cartProduct.pId = widget.snapshot.documentID;
                      cartProduct.category = widget.snapshot.data["category"];
                      cartProduct.storeId = widget.snapshot.data["storeID"];
                      cartProduct.productData =
                          ProductData.fromDocument(widget.snapshot);
                      model.addCartItem(
                          cartProduct: cartProduct, onFail: _onFail);
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onDifferentStore() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Existem Itens no seu Carrinho"),
          content: Text("Gostaria de encerrar a comprar primeiro"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Text("Sim"),
            ),
            FlatButton(
              onPressed: () {},
              child: Text("Não"),
            ),
          ],
        );
      },
    );
  }

  void _onFail() {}
}
