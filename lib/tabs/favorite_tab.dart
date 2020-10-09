import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class FavoriteTab extends StatefulWidget {
  @override
  _FavoriteTabState createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.isLoggedIn()) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    size: 120,
                    color: Colors.red,
                  ),
                  Text(
                    "Você deve estar logado para ver seus favoritos",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlatButton(
                        color: Colors.red,
                        child: Text(
                          "Entrar",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ))
                ],
              ),
            ));
      } else if (model.isLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Container();
      }
    });
  }
}
