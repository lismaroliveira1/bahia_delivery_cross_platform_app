import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/tabs/cart_tab.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartProduct cartProduct = CartProduct();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "Meu Carrinho",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: CartTab());
  }
}
