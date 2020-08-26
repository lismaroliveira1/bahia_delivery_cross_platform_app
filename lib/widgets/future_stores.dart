import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("stores").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return Container(
              height: MediaQuery.of(context).size.height - 500.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(75.0))),
              child: ListView(children: <Widget>[]),
            );
        });
  }
}
