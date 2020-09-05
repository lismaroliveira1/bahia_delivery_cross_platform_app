import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("users")
            .document(uid)
            .collection("orders")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView(
                children: snapshot.data.documents.map((e) {}).toList());
          }
        },
      );
    } else {
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
    }
  }
}
