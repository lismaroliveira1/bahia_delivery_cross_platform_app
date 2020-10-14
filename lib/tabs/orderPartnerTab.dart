import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:bahia_delivery/tiles/order_partner_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderPartnerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!model.isLoggedIn()) {
          return Container(
            padding: EdgeInsets.only(right: 130, left: 130),
            child: Column(
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
            ),
          );
        } else {
          if (model.listPartnerOders.length > 0) {
            return ListView(
                children: model.listPartnerOders.map(
              (doc) {
                return OrderPartnerTile(doc);
              },
            ).toList());
          } else {
            model.updatePartnerData();
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      },
    );
  }
}
