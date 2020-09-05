import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:bahia_delivery/tabs/cart_tab.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartProduct cartProduct = CartProduct();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "Meu Carrinho",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.red[100],
                  height: 30,
                  width: 70,
                  child: ScopedModelDescendant<CartModel>(
                    builder: (context, child, model) {
                      int p = model.products.length;
                      return Text(
                        "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                        style: TextStyle(color: Colors.black45),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        body: CartTab());
  }
}
