import 'package:bahia_delivery/screens/product_screen.dart';
import 'package:bahia_delivery/widgets/build_food_itens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreTab extends StatelessWidget {
  final DocumentSnapshot snapshot;
  StoreTab(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              expandedHeight: 300.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(snapshot.data["title"]),
                  background: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    child: Image.network(
                      snapshot.data["image"],
                      fit: BoxFit.cover,
                    ),
                  )),
            )
          ];
        },
        body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("stores")
                .document(snapshot.documentID)
                .collection("products")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                print(snapshot.data.documents.length);
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(75.0))),
                  child: ListView(
                      children: snapshot.data.documents.map((doc) {
                    return FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductScreen(doc)));
                        },
                        child: FoodItem(
                            doc.data["image"],
                            doc.data["title"],
                            'R' + '\$' + doc.data["price"],
                            doc.data["description"]));
                  }).toList()),
                );
              }
            }));
  }
}
