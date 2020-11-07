import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/be_a_partener_screen.dart';
import 'package:bahia_delivery/screens/order_screen.dart';
import 'package:bahia_delivery/screens/store_home_screen.dart';
import 'package:bahia_delivery/tiles/profile_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.isLoading || !model.isLoggedIn()) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 200.0,
            ),
            Container(
              child: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: ProfileTile(
                    title: "Chats",
                    description: "Minhas Conversas",
                    icon: Icons.message),
              ),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ProfileTile(
                  title: "Pagamentos",
                  description: "Minhas formas de pagamento",
                  icon: Icons.payment),
            ),
            FlatButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              child: ProfileTile(
                  title: "Cupons",
                  description: "Meus Cupons",
                  icon: Icons.money_off),
            ),
            ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                if (model.isLoading) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                } else {
                  return StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance
                        .collection("users")
                        .document(model.firebaseUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (model.isLoading) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        if (snapshot.data["isPartner"] != null) {
                          if (snapshot.data["isPartner"] == 1) {
                            return FlatButton(
                              padding: EdgeInsets.zero,
                              child: ProfileTile(
                                title: "Gerencie Sua loja",
                                description:
                                    "Venda seus produtos através do Bahia Delivery",
                                icon: Icons.scatter_plot,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StoreHomeScreen(),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.data["isPartner"] == 2) {
                            return FlatButton(
                              padding: EdgeInsets.zero,
                              child: ProfileTile(
                                title: "Proposta enviada",
                                description: "Analisando seus dados",
                                icon: Icons.scatter_plot,
                              ),
                              onPressed: () {},
                            );
                          } else {
                            return FlatButton(
                              padding: EdgeInsets.zero,
                              child: ProfileTile(
                                title: "Seja nosso parceiro",
                                description:
                                    "Venda seus produtos através do Bahia Delivery",
                                icon: Icons.scatter_plot,
                              ),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: Colors.white),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.8,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.red[50]),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6.5,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 10),
                                                  child: Center(
                                                    child: Image.asset(
                                                        "images/logo.png"),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 14),
                                                  child: Center(
                                                    child: Text(
                                                      "Bem vindo ao Bahia Delivery Partners",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 14),
                                                child: Text(
                                                  "Algumas informações a mais serão requeridas.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4,
                                                        child: RaisedButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          color: Colors.red,
                                                          child: Text(
                                                            "Voltar",
                                                          ),
                                                          textColor:
                                                              Colors.white,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          disabledColor:
                                                              Colors.grey,
                                                          disabledTextColor:
                                                              Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              20,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                          child: RaisedButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            color: Colors.red,
                                                            child: Text(
                                                              "Ok, vamos lá!",
                                                            ),
                                                            textColor:
                                                                Colors.white,
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BeAParterScreen(),
                                                              ));
                                                            },
                                                            disabledColor:
                                                                Colors.grey,
                                                            disabledTextColor:
                                                                Colors.black,
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  }),
                            );
                          }
                        } else {
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        }
                      } else {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                    },
                  );
                }
              },
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ProfileTile(
                  title: "Notificações",
                  description: "Gerencie as suas notificações",
                  icon: Icons.notifications_active),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderScreen(),
                ));
              },
              child: ProfileTile(
                title: "Pedidos",
                description: "Acompanhe seus pedidos",
                icon: Icons.list,
              ),
            ),
            FlatButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              child: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: ProfileTile(
                  title: "Minha Conta",
                  description: "Edite seu peril",
                  icon: Icons.list,
                ),
              ),
            ),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: ProfileTile(
                title: "Configurações",
                description: "Configure o apicativo do seu jeito",
                icon: Icons.phonelink_setup,
              ),
            ),
          ],
        ),
      );
    });
  }
}
