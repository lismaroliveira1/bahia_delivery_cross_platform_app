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
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[/*//TODO implemetar a favorite app bar*/];
          },
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("users")
                .document(model.firebaseUser.uid)
                .collection("favorites")
                .getDocuments(),
            builder: (context, favoriteSnapshot) {
              if (!favoriteSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                bool status = false;
                Widget listView = ListView(
                    children: favoriteSnapshot.data.documents.map((doc) {
                  if (doc.data["status"]) {
                    status = true;
                    return FutureBuilder<DocumentSnapshot>(
                      future: Firestore.instance
                          .collection("stores")
                          .document(doc.documentID)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 120,
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data["title"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: snapshot.data["image"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          child: Center(
                                            child: Text(
                                                snapshot.data["description"]),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  }
                }).toList());
                if (status) {
                  return listView;
                } else {
                  return Container(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 140,
                          color: Colors.red,
                        ),
                        Text(
                          "Você não tem lojas favoritas",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 20),
                        ),
                      ],
                    )),
                  );
                }
              }
            },
          ),
        );
      }
    });
  }
}
