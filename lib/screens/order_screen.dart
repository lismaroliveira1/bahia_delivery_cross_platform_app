import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:bahia_delivery/tabs/orderPartnerTab.dart';
import 'package:bahia_delivery/tabs/order_tab.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isVerifiedListStoreOrders = false;
  bool isVerifiedListUserOrders = false;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (!isVerifiedListStoreOrders) {
          model.updatePartnerData();
          isVerifiedListStoreOrders = true;
        }
        if (!isVerifiedListUserOrders) {
          model.getUserOrder();
          isVerifiedListUserOrders = true;
        }
        if (model.isLoading) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!model.isLoggedIn()) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.view_list,
                size: 80.0,
                color: Colors.red,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "Faça login para login para acompanhar os produtos",
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
          );
        } else {
          if (model.listPartnerOders.length > 0) {
            return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("Pedidos"),
                    centerTitle: true,
                    bottom: TabBar(
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text("Pedidos do cliente"),
                        ),
                        Tab(
                          child: Text("Pedidos da loja"),
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    OrderTab(),
                    OrderPartnerTab(),
                  ]),
                ));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Pedidos de " + model.userName),
              ),
              body: OrderTab(),
            );
          }
        }
      },
    );
  }
}
