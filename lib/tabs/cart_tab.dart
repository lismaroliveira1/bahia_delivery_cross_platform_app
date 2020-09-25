import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:bahia_delivery/tiles/cart_tile.dart';
import 'package:bahia_delivery/widgets/cart_price.dart';
import 'package:bahia_delivery/widgets/chip_card.dart';
import 'package:bahia_delivery/widgets/discount_card.dart';
import 'package:bahia_delivery/widgets/payment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  CartProduct cartProduct = CartProduct();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(builder: (context, child, model) {
      if (model.isLoading && UserModel.of(context).isLoggedIn()) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (!UserModel.of(context).isLoggedIn()) {
        return Container(
          padding: EdgeInsets.only(right: 130, left: 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.remove_shopping_cart,
                size: 80.0,
                color: Colors.red,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "Faça login para adcionar produtos!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 55,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                  ),
                ),
              )
            ],
          ),
        );
      } else if (model.products == null || model.products.length == 0) {
        return Center(
          child: Text(
            "Nenhum produto no carrinho",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("users")
              .document(UserModel.of(context).firebaseUser.uid)
              .collection("cart")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Seu Carrinho está vázio"),
              );
            } else {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: model.products.map((products) {
                        return CartTile(products);
                      }).toList(),
                    )),
                    DiscountCard(),
                    ShipCard(),
                    PaymentCard(),
                    CartPrice(() async {
                      String orderId = await model.finishOrder();
                      if (orderId != null) {
                        //TODO implementar um widget para mostrar o resumo do pedido
                      } else {}
                    }),
                  ],
                ),
              );
            }
          },
        );
      }
    });
  }
}
