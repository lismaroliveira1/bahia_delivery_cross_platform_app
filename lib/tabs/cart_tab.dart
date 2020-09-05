import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:bahia_delivery/tiles/cart_tile.dart';
import 'package:bahia_delivery/widgets/cart_price.dart';
import 'package:bahia_delivery/widgets/chip_card.dart';
import 'package:bahia_delivery/widgets/discount_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  CartProduct cartProduct = CartProduct();

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
              return Column(
                children: [
                  Expanded(
                      child: ListView(
                    children: model.products.map((products) {
                      return CartTile(products);
                    }).toList(),
                  )),
                  DiscountCard(),
                  ShipCard(),
                  CartPrice(() async {
                    String orderId = await model.finishOrder();
                    if (orderId != null) {
                      print("ok");
                    }
                  })
                ],
              );
            }
          },
        );
      }
    });
  }
}

/*ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data.documents.map((doc) {
                        return Card(
                          child: FutureBuilder<DocumentSnapshot>(
                            future: Firestore.instance
                                .collection("stores")
                                .document(doc.data["storeId"])
                                .collection("products")
                                .document(doc.data["pid"])
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      height: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                  placeholder:
                                                      kTransparentImage,
                                                  image: snapshot.data["image"],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data["title"],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17.0),
                                                  ),
                                                  Text(
                                                    "R\$ ${snapshot.data["price"]}",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      IconButton(
                                                        icon:
                                                            Icon(Icons.remove),
                                                        onPressed: () {},
                                                      ),
                                                      Text(cartProduct.quantify
                                                          .toString()),
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(Icons.add),
                                                      ),
                                                      FlatButton(
                                                        child: Text("Remover"),
                                                        textColor:
                                                            Colors.grey[500],
                                                        onPressed: () {},
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),*/
